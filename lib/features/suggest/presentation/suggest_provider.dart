import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/recommendation_service.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';

/// Provider for SafetyFilter singleton
final safetyFilterProvider = Provider<SafetyFilter>((ref) {
  return const SafetyFilter();
});

/// Provider for Scorer singleton
final scorerProvider = Provider<Scorer>((ref) {
  return const Scorer();
});

/// Provider for RecommendationService
final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService(
    safetyFilter: ref.watch(safetyFilterProvider),
    scorer: ref.watch(scorerProvider),
    recipesDao: ref.watch(recipesDaoProvider),
    ingredientsDao: ref.watch(ingredientsDaoProvider),
    feedbackDao: ref.watch(feedbackDaoProvider),
  );
});

/// Provider executing recommendation query for a given request
final mealSuggestionsProvider =
    FutureProvider.family<List<MealRecommendation>, MealSuggestionRequest>((
      ref,
      request,
    ) async {
      // Ensure seed data is ready
      final seedService = ref.watch(seedServiceProvider);
      await seedService.seedIfNeeded();

      final service = ref.watch(recommendationServiceProvider);
      return service.getRecommendations(request);
    });

/// Provider managing multi-selected kid IDs for suggestions
class SelectedKidIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final kids = ref.watch(kidsListNotifierProvider).asData?.value ?? const [];
    // Default to selecting all children
    return kids.map((k) => k.id).toSet();
  }

  void toggleKid(String id) {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      if (next.length > 1) {
        next.remove(id);
      }
    } else {
      next.add(id);
    }
    state = next;
  }

  void selectAll(Iterable<String> allIds) {
    state = allIds.toSet();
  }

  void selectSingle(String id) {
    state = {id};
  }
}

final selectedKidIdsProvider =
    NotifierProvider<SelectedKidIdsNotifier, Set<String>>(
      SelectedKidIdsNotifier.new,
    );

/// State holding the currently active suggestion request for results screen
class CurrentSuggestionRequestNotifier
    extends Notifier<MealSuggestionRequest?> {
  @override
  MealSuggestionRequest? build() => null;

  void setRequest(MealSuggestionRequest request) {
    state = request;
  }
}

final currentSuggestionRequestProvider =
    NotifierProvider<CurrentSuggestionRequestNotifier, MealSuggestionRequest?>(
      CurrentSuggestionRequestNotifier.new,
    );
