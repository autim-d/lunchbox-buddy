import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/ai/ai_prompts.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_ranking_response.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/recommendation_service.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

/// Top-level parser for isolate execution via `compute`
AiRankingResponse _parseRankingInIsolate(Map<String, dynamic> json) {
  return AiRankingResponse.fromJson(json);
}

/// Service implementing Feature B: AI Ranking and Adaptation.
/// Takes top 10 rule-based candidates, adapts the best 3 with warm reasons & tips,
/// enforces candidate ID validity, re-runs SafetyFilter, and caches results in Drift.
class AiRankingService {
  AiRankingService({
    required this.aiClient,
    required this.recommendationService,
    required this.safetyFilter,
    required this.appMetadataDao,
  });

  final AiClient aiClient;
  final RecommendationService recommendationService;
  final SafetyFilter safetyFilter;
  final AppMetadataDao appMetadataDao;

  /// Alias matching the specification name `rankAndAdapt`
  Future<List<MealRecommendation>> rankAndAdapt({
    required MealSuggestionRequest request,
    required List<Recipe> allRecipes,
    Map<String, Ingredient>? ingredientMap,
    List<Ingredient>? allIngredients,
    List<MealFeedback> feedbacks = const [],
    DateTime? referenceDate,
  }) {
    final map =
        ingredientMap ??
        {
          for (final ing in (allIngredients ?? const <Ingredient>[]))
            ing.id: ing,
        };
    return getAiRankedRecommendations(
      request: request,
      allRecipes: allRecipes,
      ingredientMap: map,
      feedbacks: feedbacks,
      referenceDate: referenceDate,
    );
  }

  /// Generates 3 personalized, AI-adapted recommendations with silent fallback to rule-based.
  Future<List<MealRecommendation>> getAiRankedRecommendations({
    required MealSuggestionRequest request,
    required List<Recipe> allRecipes,
    required Map<String, Ingredient> ingredientMap,
    List<MealFeedback> feedbacks = const [],
    DateTime? referenceDate,
  }) async {
    // 1. Get top 10 safe candidates from rule-based engine
    final safeRecipes = safetyFilter.filterSafeRecipes(
      recipes: allRecipes,
      kids: request.selectedKids,
      ingredientMap: ingredientMap,
      referenceDate: referenceDate,
    );

    final candidates = recommendationService.scorer.rankTopRecommendations(
      safeRecipes: safeRecipes,
      request: request,
      ingredientMap: ingredientMap,
      recentFeedbacks: feedbacks,
      referenceDate: referenceDate,
      limit: 10,
    );

    // If fewer than 3 candidates available, return what we have directly
    if (candidates.length <= 3) {
      return candidates;
    }

    final candidateMap = {for (final c in candidates) c.recipe.id: c};
    final cacheKey = _computeCacheKey(request, candidates);

    // 2. Check local Drift cache first
    try {
      final cachedJsonString = await appMetadataDao.getValue(cacheKey);
      if (cachedJsonString != null && cachedJsonString.isNotEmpty) {
        final decoded = jsonDecode(cachedJsonString) as Map<String, dynamic>;
        final cachedResponse = _parseRankingInIsolate(decoded);
        final assembled = _assembleRankedResults(
          response: cachedResponse,
          candidateMap: candidateMap,
          request: request,
          ingredientMap: ingredientMap,
          referenceDate: referenceDate,
        );
        if (assembled.isNotEmpty) {
          return assembled;
        }
      }
    } catch (e) {
      debugPrint('AI ranking cache read skipped: $e');
    }

    // 3. Invoke Firebase AI with 8s timeout and prompt
    try {
      final prompt = AiPrompts.buildRankingPrompt(
        candidates: candidates.map((c) => c.recipe).toList(),
        selectedKids: request.selectedKids,
        recentFeedbacks: feedbacks,
        motherNote: request.freeTextNote,
      );

      final result = await aiClient.generateStructured<AiRankingResponse>(
        prompt: prompt,
        responseSchema: AiPrompts.rankingSchema,
        systemInstruction: AiPrompts.rankingSystemInstruction,
        timeoutSeconds: 8,
        retryOnFormatError: true,
        parser: (json) {
          try {
            return _parseRankingInIsolate(json);
          } catch (_) {
            return AiRankingResponse.fromJson(json);
          }
        },
      );

      return await result.when(
        success: (response) async {
          final assembled = _assembleRankedResults(
            response: response,
            candidateMap: candidateMap,
            request: request,
            ingredientMap: ingredientMap,
            referenceDate: referenceDate,
          );

          if (assembled.length >= 3) {
            // Cache successful valid result in Drift
            try {
              await appMetadataDao.setValue(
                cacheKey,
                jsonEncode(response.toJson()),
              );
            } catch (cacheError) {
              debugPrint('Failed to cache AI ranking: $cacheError');
            }
            return assembled.take(3).toList();
          }

          // If AI returned fewer than 3 or invalid IDs, fall back silently
          return candidates.take(3).toList();
        },
        error: (failure) {
          // Silent fallback to rule-based top 3
          debugPrint('AI Ranking fallback triggered: $failure');
          return candidates.take(3).toList();
        },
      );
    } catch (e) {
      debugPrint('AI Ranking exception, falling back silently: $e');
      return candidates.take(3).toList();
    }
  }

  /// Assembles, validates recipe IDs, and re-runs SafetyFilter on AI selections
  List<MealRecommendation> _assembleRankedResults({
    required AiRankingResponse response,
    required Map<String, MealRecommendation> candidateMap,
    required MealSuggestionRequest request,
    required Map<String, Ingredient> ingredientMap,
    DateTime? referenceDate,
  }) {
    final validAdapted = <MealRecommendation>[];
    final seenIds = <String>{};

    for (final item in response.items) {
      // Rule: Reject any output with unknown IDs
      final candidate = candidateMap[item.recipeId];
      if (candidate == null || seenIds.contains(item.recipeId)) {
        continue;
      }
      seenIds.add(item.recipeId);

      validAdapted.add(
        candidate.copyWith(
          aiReason: item.reasonAr,
          substitutionTip: item.substitutionTip,
          isAiRanked: true,
        ),
      );
    }

    if (validAdapted.isEmpty) {
      return const [];
    }

    // Rule: Run the SafetyFilter again on the final selection
    final finalRecipes = validAdapted.map((m) => m.recipe).toList();
    final verifiedSafeRecipes = safetyFilter.filterSafeRecipes(
      recipes: finalRecipes,
      kids: request.selectedKids,
      ingredientMap: ingredientMap,
      referenceDate: referenceDate,
    );

    final safeIdSet = verifiedSafeRecipes.map((r) => r.id).toSet();
    final verifiedRecommendations = validAdapted
        .where((m) => safeIdSet.contains(m.recipe.id))
        .toList();

    // If any item was dropped by safety check, backfill with remaining rule candidates
    if (verifiedRecommendations.length < 3) {
      for (final fallback in candidateMap.values) {
        if (!seenIds.contains(fallback.recipe.id)) {
          verifiedRecommendations.add(fallback);
          if (verifiedRecommendations.length == 3) break;
        }
      }
    }

    return verifiedRecommendations;
  }

  /// Computes a deterministic MD5 hash for drift caching
  String _computeCacheKey(
    MealSuggestionRequest request,
    List<MealRecommendation> candidates,
  ) {
    final kidsConstraints = request.selectedKids
        .map((k) => '${k.id}:${k.allergies.join("-")}:${k.dislikes.join("-")}')
        .join('|');
    final candidateIds = candidates.map((c) => c.recipe.id).join(',');
    final note = request.freeTextNote ?? '';
    final raw =
        'ai_rank:$kidsConstraints:$candidateIds:$note:${request.mealType}:${request.maxMinutes}';
    final digest = md5.convert(utf8.encode(raw));
    return 'ai_rank_$digest';
  }
}

/// Riverpod provider for AiRankingService
final aiRankingServiceProvider = Provider<AiRankingService>((ref) {
  return AiRankingService(
    aiClient: ref.watch(aiClientProvider),
    recommendationService: ref.watch(recommendationServiceProvider),
    safetyFilter: ref.watch(safetyFilterProvider),
    appMetadataDao: ref.watch(metadataDaoProvider),
  );
});
