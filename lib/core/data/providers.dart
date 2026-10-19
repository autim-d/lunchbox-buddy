import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/services/seed_service.dart';

/// AppDatabase singleton provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// DAOs providers
final recipesDaoProvider = Provider<RecipesDao>((ref) {
  return RecipesDao(ref.watch(appDatabaseProvider));
});

final ingredientsDaoProvider = Provider<IngredientsDao>((ref) {
  return IngredientsDao(ref.watch(appDatabaseProvider));
});

final kidProfilesDaoProvider = Provider<KidProfilesDao>((ref) {
  return KidProfilesDao(ref.watch(appDatabaseProvider));
});

final groceryDaoProvider = Provider<GroceryDao>((ref) {
  return GroceryDao(ref.watch(appDatabaseProvider));
});

final feedbackDaoProvider = Provider<FeedbackDao>((ref) {
  return FeedbackDao(ref.watch(appDatabaseProvider));
});

final metadataDaoProvider = Provider<AppMetadataDao>((ref) {
  return AppMetadataDao(ref.watch(appDatabaseProvider));
});

/// SeedService provider
final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(
    db: ref.watch(appDatabaseProvider),
    ingredientsDao: ref.watch(ingredientsDaoProvider),
    recipesDao: ref.watch(recipesDaoProvider),
    metadataDao: ref.watch(metadataDaoProvider),
  );
});

/// Provider that guarantees database is seeded and yields all recipes
final allRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final seedService = ref.watch(seedServiceProvider);
  await seedService.seedIfNeeded();
  final recipesDao = ref.watch(recipesDaoProvider);
  return recipesDao.getAllRecipes();
});

/// Provider that guarantees database is seeded and yields all ingredients
final allIngredientsProvider = FutureProvider<List<Ingredient>>((ref) async {
  final seedService = ref.watch(seedServiceProvider);
  await seedService.seedIfNeeded();
  final ingredientsDao = ref.watch(ingredientsDaoProvider);
  return ingredientsDao.getAllIngredients();
});

/// Notifier managing recorded meal feedbacks (most recent first)
class FeedbackListNotifier extends AsyncNotifier<List<MealFeedback>> {
  @override
  FutureOr<List<MealFeedback>> build() async {
    final dao = ref.watch(feedbackDaoProvider);
    return dao.getAllFeedback();
  }

  Future<void> addFeedback(MealFeedback feedback) async {
    final dao = ref.read(feedbackDaoProvider);
    await dao.insertFeedback(feedback);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteFeedback(String id) async {
    final dao = ref.read(feedbackDaoProvider);
    await dao.deleteFeedback(id);
    ref.invalidateSelf();
    await future;
  }
}

final feedbackListNotifierProvider =
    AsyncNotifierProvider<FeedbackListNotifier, List<MealFeedback>>(
      FeedbackListNotifier.new,
    );

/// Provider checking whether a recipe was ever marked as 'loved' by any kid
final isRecipeLovedProvider = Provider.family<bool, String>((ref, recipeId) {
  final feedbacksAsync = ref.watch(feedbackListNotifierProvider);
  return feedbacksAsync.maybeWhen(
    data: (feedbacks) => feedbacks.any(
      (fb) => fb.recipeId == recipeId && fb.reaction == 'loved',
    ),
    orElse: () => false,
  );
});

/// Stream provider for all recorded meal feedbacks (most recent first)
final allFeedbacksStreamProvider = StreamProvider<List<MealFeedback>>((ref) {
  final dao = ref.watch(feedbackDaoProvider);
  return dao.watchAllFeedback();
});

/// Future provider for all recorded meal feedbacks
final allFeedbacksFutureProvider = FutureProvider<List<MealFeedback>>((
  ref,
) async {
  final dao = ref.watch(feedbackDaoProvider);
  return dao.getAllFeedback();
});
