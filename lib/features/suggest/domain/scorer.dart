import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';

/// Pure Dart rule-based scorer for ranking recipes deterministically without AI.
///
/// Score formulation:
/// score = tag match + time fit + ingredients-on-hand ratio + kid likes
///         - dislikes - recent feedback penalty (refused drop, loved rise slightly, recent repeats drop)
class Scorer {
  const Scorer();

  /// Scores a single recipe against the request, ingredient metadata, and recent feedback history.
  MealRecommendation scoreRecipe({
    required Recipe recipe,
    required MealSuggestionRequest request,
    required Map<String, Ingredient> ingredientMap,
    List<MealFeedback> recentFeedbacks = const [],
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final breakdown = <String, double>{};

    // -------------------------------------------------------------------------
    // 1. Tag Match Score
    // -------------------------------------------------------------------------
    double tagMatchScore = 0.0;

    // Mood tags matching (+3.0 per matching tag)
    for (final moodTag in request.moodTags) {
      if (recipe.tags.contains(moodTag)) {
        tagMatchScore += 3.0;
      }
    }

    // Meal type matching (+4.0)
    final mealType = request.mealType.toLowerCase().trim();
    if (mealType == 'lunchbox') {
      if (recipe.tags.contains('lunchbox-friendly') ||
          recipe.tags.contains('lunchbox')) {
        tagMatchScore += 4.0;
      }
    } else if (recipe.tags.contains(mealType)) {
      tagMatchScore += 4.0;
    }

    // Picky kid tag bonuses: hidden-veggies & simple recipes
    final hasPickyKid = request.selectedKids.any((k) => k.pickyLevel >= 2);
    if (hasPickyKid && recipe.tags.contains('hidden-veggies')) {
      tagMatchScore += 3.0;
    }

    breakdown['tagMatch'] = tagMatchScore;

    // -------------------------------------------------------------------------
    // 2. Time Fit Score
    // -------------------------------------------------------------------------
    double timeFitScore = 0.0;
    final totalMinutes = recipe.prepMinutes + recipe.cookMinutes;

    if (request.maxMinutes != null && request.maxMinutes! > 0) {
      if (totalMinutes <= request.maxMinutes!) {
        timeFitScore += 5.0;
        // Bonus for being extra quick relative to max allowance
        final savings =
            (request.maxMinutes! - totalMinutes) / request.maxMinutes!;
        timeFitScore += savings * 2.0;
      } else {
        // Penalty for exceeding desired time limit
        final excess = (totalMinutes - request.maxMinutes!).toDouble();
        timeFitScore -= excess * 0.5;
      }
    } else {
      // General quickness baseline when no time constraint is given
      if (totalMinutes <= 15) {
        timeFitScore += 3.0;
      } else if (totalMinutes <= 25) {
        timeFitScore += 1.5;
      }
    }

    breakdown['timeFit'] = timeFitScore;

    // -------------------------------------------------------------------------
    // 3. Ingredients-on-hand ratio Score (up to +10.0)
    // -------------------------------------------------------------------------
    double onHandRatioScore = 0.0;
    if (request.availableIngredientIds != null &&
        request.availableIngredientIds!.isNotEmpty &&
        recipe.ingredients.isNotEmpty) {
      final availableSet = request.availableIngredientIds!.toSet();
      int matchCount = 0;

      for (final ing in recipe.ingredients) {
        if (availableSet.contains(ing.ingredientId)) {
          matchCount++;
        }
      }

      final ratio = matchCount / recipe.ingredients.length;
      onHandRatioScore = ratio * 10.0;
    }

    breakdown['onHand'] = onHandRatioScore;

    // -------------------------------------------------------------------------
    // 4. Kid Likes Score (+2.5 per liked ingredient)
    // -------------------------------------------------------------------------
    double likesScore = 0.0;
    final allLikes = request.selectedKids.expand((k) => k.likes).toSet();

    if (allLikes.isNotEmpty) {
      for (final ing in recipe.ingredients) {
        if (allLikes.contains(ing.ingredientId)) {
          likesScore += 2.5;
        }
      }
    }

    breakdown['likes'] = likesScore;

    // -------------------------------------------------------------------------
    // 5. Kid Dislikes Penalty (-4.0 to -6.0 per disliked ingredient)
    // -------------------------------------------------------------------------
    double dislikesPenalty = 0.0;
    final allDislikes = request.selectedKids.expand((k) => k.dislikes).toSet();

    if (allDislikes.isNotEmpty) {
      for (final ing in recipe.ingredients) {
        if (allDislikes.contains(ing.ingredientId)) {
          final perPenalty = hasPickyKid ? 6.0 : 4.0;
          dislikesPenalty += perPenalty;
        }
      }
    }

    breakdown['dislikes'] = dislikesPenalty;

    // -------------------------------------------------------------------------
    // 6. Recent Feedback Adjustment
    // -------------------------------------------------------------------------
    double feedbackAdjustment = 0.0;
    final selectedKidIds = request.selectedKids.map((k) => k.id).toSet();
    final recipeFeedbacks = recentFeedbacks
        .where(
          (f) =>
              f.recipeId == recipe.id &&
              (f.kidId == null ||
                  selectedKidIds.isEmpty ||
                  selectedKidIds.contains(f.kidId)),
        )
        .toList();

    for (final fb in recipeFeedbacks) {
      final daysAgo = now.difference(fb.date).inDays;

      // Only consider feedback within the last 14 days
      if (daysAgo <= 14) {
        if (fb.reaction == 'refused') {
          feedbackAdjustment -= 15.0;
        } else if (fb.reaction == 'loved') {
          feedbackAdjustment += 3.0;
        }

        // Recent repeats penalty (cooked within last 3 days)
        if (daysAgo <= 3) {
          feedbackAdjustment -= 5.0;
        }
      }
    }

    breakdown['feedback'] = feedbackAdjustment;

    // Total final score
    final totalScore =
        tagMatchScore +
        timeFitScore +
        onHandRatioScore +
        likesScore -
        dislikesPenalty +
        feedbackAdjustment;

    // -------------------------------------------------------------------------
    // 7. Determine One-Line Reason String Key
    // -------------------------------------------------------------------------
    final reasonKey = _determineReasonKey(
      onHandScore: onHandRatioScore,
      likesScore: likesScore,
      feedbackScore: feedbackAdjustment,
      hasPickyKid: hasPickyKid,
      recipe: recipe,
      request: request,
      totalMinutes: totalMinutes,
    );

    return MealRecommendation(
      recipe: recipe,
      score: totalScore,
      reasonKey: reasonKey,
      breakdown: breakdown,
    );
  }

  /// Selects the top 3 recommendations from a list of safe recipes.
  /// Results are 100% deterministic, breaking score ties by recipe ID.
  List<MealRecommendation> rankTopRecommendations({
    required List<Recipe> safeRecipes,
    required MealSuggestionRequest request,
    required Map<String, Ingredient> ingredientMap,
    List<MealFeedback> recentFeedbacks = const [],
    DateTime? referenceDate,
    int limit = 3,
  }) {
    if (safeRecipes.isEmpty) return const [];

    final scored = safeRecipes.map((recipe) {
      return scoreRecipe(
        recipe: recipe,
        request: request,
        ingredientMap: ingredientMap,
        recentFeedbacks: recentFeedbacks,
        referenceDate: referenceDate,
      );
    }).toList();

    // Sort descending by score; tie-break deterministically by recipe.id
    scored.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }
      return a.recipe.id.compareTo(b.recipe.id);
    });

    return scored.take(limit).toList();
  }

  String _determineReasonKey({
    required double onHandScore,
    required double likesScore,
    required double feedbackScore,
    required bool hasPickyKid,
    required Recipe recipe,
    required MealSuggestionRequest request,
    required int totalMinutes,
  }) {
    if (onHandScore >= 5.0) {
      return 'reason_ingredients_on_hand';
    }
    if (likesScore > 0 || feedbackScore > 0) {
      return 'reason_kid_favorite';
    }
    if (hasPickyKid && recipe.tags.contains('hidden-veggies')) {
      return 'reason_hidden_veggies';
    }
    if (request.mealType == 'lunchbox' &&
        (recipe.tags.contains('lunchbox-friendly') ||
            recipe.tags.contains('lunchbox'))) {
      return 'reason_lunchbox_friendly';
    }
    if (totalMinutes <= 15 ||
        (request.maxMinutes != null && totalMinutes <= request.maxMinutes!)) {
      return 'reason_quick_prep';
    }
    return 'reason_balanced_meal';
  }
}
