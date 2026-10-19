import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';

/// Pure Dart service coordinating SafetyFilter and Scorer to produce
/// deterministic, allergen-safe top-3 meal suggestions without AI.
class RecommendationService {
  RecommendationService({
    required this.safetyFilter,
    required this.scorer,
    required this.recipesDao,
    required this.ingredientsDao,
    required this.feedbackDao,
  });

  final SafetyFilter safetyFilter;
  final Scorer scorer;
  final RecipesDao recipesDao;
  final IngredientsDao ingredientsDao;
  final FeedbackDao feedbackDao;

  /// Generates the top 3 safe, rule-ranked meal recommendations
  Future<List<MealRecommendation>> getRecommendations(
    MealSuggestionRequest request, {
    DateTime? referenceDate,
  }) async {
    // 1. Fetch recipes, ingredients, and feedback from local storage
    final allRecipes = await recipesDao.getAllRecipes();
    final allIngredients = await ingredientsDao.getAllIngredients();
    final allFeedback = await feedbackDao.getAllFeedback();

    final ingredientMap = <String, Ingredient>{
      for (final ing in allIngredients) ing.id: ing,
    };

    return getRecommendationsFromCorpus(
      request: request,
      allRecipes: allRecipes,
      ingredientMap: ingredientMap,
      feedbacks: allFeedback,
      referenceDate: referenceDate,
    );
  }

  /// Synchronous in-memory pipeline useful for tests and pre-loaded datasets
  List<MealRecommendation> getRecommendationsFromCorpus({
    required MealSuggestionRequest request,
    required List<Recipe> allRecipes,
    required Map<String, Ingredient> ingredientMap,
    List<MealFeedback> feedbacks = const [],
    DateTime? referenceDate,
  }) {
    // 2. Filter strictly through deterministic SafetyFilter
    final safeRecipes = safetyFilter.filterSafeRecipes(
      recipes: allRecipes,
      kids: request.selectedKids,
      ingredientMap: ingredientMap,
      referenceDate: referenceDate,
    );

    // 3. Score and rank top 3
    return scorer.rankTopRecommendations(
      safeRecipes: safeRecipes,
      request: request,
      ingredientMap: ingredientMap,
      recentFeedbacks: feedbacks,
      referenceDate: referenceDate,
      limit: 3,
    );
  }
}
