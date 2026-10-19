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
