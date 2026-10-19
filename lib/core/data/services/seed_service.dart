import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';

/// Service responsible for seeding the curated recipe corpus and canonical
/// ingredients into the local Drift database.
class SeedService {
  SeedService({
    required this.db,
    IngredientsDao? ingredientsDao,
    RecipesDao? recipesDao,
    AppMetadataDao? metadataDao,
  }) : ingredientsDao = ingredientsDao ?? IngredientsDao(db),
       recipesDao = recipesDao ?? RecipesDao(db),
       metadataDao = metadataDao ?? AppMetadataDao(db);

  final AppDatabase db;
  final IngredientsDao ingredientsDao;
  final RecipesDao recipesDao;
  final AppMetadataDao metadataDao;

  static const String seedVersionKey = 'recipe_corpus_seed_version';
  static const String currentSeedVersion = '1.0.0';

  /// Seeds ingredients and recipes if not already seeded with [currentSeedVersion]
  /// or if [force] is true.
  ///
  /// Returns `true` if seeding was executed, `false` if skipped.
  Future<bool> seedIfNeeded({
    bool force = false,
    String? ingredientsJsonString,
    String? recipesJsonString,
  }) async {
    if (!force) {
      final existingVersion = await metadataDao.getValue(seedVersionKey);
      if (existingVersion == currentSeedVersion) {
        // Already seeded at current version
        return false;
      }
    }

    // 1. Load & parse canonical ingredients
    final rawIngredients =
        ingredientsJsonString ??
        await rootBundle.loadString('assets/data/ingredients.json');
    final ingredientsList = (jsonDecode(rawIngredients) as List<dynamic>)
        .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
        .toList();

    await ingredientsDao.insertIngredients(ingredientsList);

    // 2. Load & parse curated recipes
    final rawRecipes =
        recipesJsonString ??
        await rootBundle.loadString('assets/data/recipes.json');
    final recipesList = (jsonDecode(rawRecipes) as List<dynamic>)
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();

    await recipesDao.insertRecipes(recipesList);

    // 3. Mark seed version in metadata
    await metadataDao.setValue(seedVersionKey, currentSeedVersion);

    return true;
  }

  /// Forces a complete re-seeding regardless of current version flag
  Future<void> forceReSeed({
    String? ingredientsJsonString,
    String? recipesJsonString,
  }) async {
    await seedIfNeeded(
      force: true,
      ingredientsJsonString: ingredientsJsonString,
      recipesJsonString: recipesJsonString,
    );
  }
}
