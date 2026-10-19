import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';

/// DAO for managing Recipe records and their constituent ingredients
class RecipesDao {
  RecipesDao(this.db);
  final AppDatabase db;

  Future<List<Recipe>> getAllRecipes() async {
    final recipeEntries = await db.select(db.recipesTable).get();
    final allIngredientEntries = await db
        .select(db.recipeIngredientsTable)
        .get();

    // Group ingredient entries by recipeId
    final ingredientsByRecipeId = <String, List<RecipeIngredient>>{};
    for (final entry in allIngredientEntries) {
      final list = ingredientsByRecipeId.putIfAbsent(
        entry.recipeId,
        () => <RecipeIngredient>[],
      );
      list.add(
        RecipeIngredient(
          ingredientId: entry.ingredientId,
          quantity: entry.quantity,
          unit: entry.unit,
          displayText: entry.displayText,
          optional: entry.optional,
        ),
      );
    }

    return recipeEntries.map((entry) {
      final stepsList = List<String>.from(
        jsonDecode(entry.steps) as List<dynamic>,
      );
      final tagsList = List<String>.from(
        jsonDecode(entry.tags) as List<dynamic>,
      );
      final ingredients =
          ingredientsByRecipeId[entry.id] ?? const <RecipeIngredient>[];

      return Recipe(
        id: entry.id,
        title: entry.title,
        description: entry.description,
        ingredients: ingredients,
        steps: stepsList,
        prepMinutes: entry.prepMinutes,
        cookMinutes: entry.cookMinutes,
        servings: entry.servings,
        tags: tagsList,
        source: entry.source,
        ageMinMonths: entry.ageMinMonths,
        imagePath: entry.imagePath,
        safetyVersion: entry.safetyVersion,
      );
    }).toList();
  }

  Future<Recipe?> getRecipeById(String id) async {
    final entry = await (db.select(
      db.recipesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (entry == null) return null;

    final ingredientEntries = await (db.select(
      db.recipeIngredientsTable,
    )..where((tbl) => tbl.recipeId.equals(id))).get();

    final ingredients = ingredientEntries
        .map(
          (e) => RecipeIngredient(
            ingredientId: e.ingredientId,
            quantity: e.quantity,
            unit: e.unit,
            displayText: e.displayText,
            optional: e.optional,
          ),
        )
        .toList();

    final stepsList = List<String>.from(
      jsonDecode(entry.steps) as List<dynamic>,
    );
    final tagsList = List<String>.from(jsonDecode(entry.tags) as List<dynamic>);

    return Recipe(
      id: entry.id,
      title: entry.title,
      description: entry.description,
      ingredients: ingredients,
      steps: stepsList,
      prepMinutes: entry.prepMinutes,
      cookMinutes: entry.cookMinutes,
      servings: entry.servings,
      tags: tagsList,
      source: entry.source,
      ageMinMonths: entry.ageMinMonths,
      imagePath: entry.imagePath,
      safetyVersion: entry.safetyVersion,
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    await db.transaction(() async {
      await db
          .into(db.recipesTable)
          .insertOnConflictUpdate(
            RecipeEntry(
              id: recipe.id,
              title: recipe.title,
              description: recipe.description,
              steps: jsonEncode(recipe.steps),
              prepMinutes: recipe.prepMinutes,
              cookMinutes: recipe.cookMinutes,
              servings: recipe.servings,
              tags: jsonEncode(recipe.tags),
              source: recipe.source,
              ageMinMonths: recipe.ageMinMonths,
              imagePath: recipe.imagePath,
              safetyVersion: recipe.safetyVersion,
            ),
          );

      // Remove existing ingredients for this recipe before re-inserting
      await (db.delete(
        db.recipeIngredientsTable,
      )..where((tbl) => tbl.recipeId.equals(recipe.id))).go();

      for (final ing in recipe.ingredients) {
        await db
            .into(db.recipeIngredientsTable)
            .insert(
              RecipeIngredientsTableCompanion.insert(
                recipeId: recipe.id,
                ingredientId: ing.ingredientId,
                quantity: Value(ing.quantity),
                unit: Value(ing.unit),
                displayText: Value(ing.displayText),
                optional: Value(ing.optional),
              ),
            );
      }
    });
  }

  Future<void> insertRecipes(List<Recipe> recipes) async {
    await db.transaction(() async {
      for (final recipe in recipes) {
        await insertRecipe(recipe);
      }
    });
  }

  Future<int> countRecipes() async {
    final countExp = db.recipesTable.id.count();
    final query = db.selectOnly(db.recipesTable)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}

/// DAO for managing Ingredient master records
class IngredientsDao {
  IngredientsDao(this.db);
  final AppDatabase db;

  Future<List<Ingredient>> getAllIngredients() async {
    final entries = await db.select(db.ingredientsTable).get();
    return entries.map((e) {
      final allergensList = List<String>.from(
        jsonDecode(e.allergens) as List<dynamic>,
      );
      return Ingredient(
        id: e.id,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
        category: e.category,
        allergens: allergensList,
        commonInRegion: e.commonInRegion,
      );
    }).toList();
  }

  Future<Ingredient?> getIngredientById(String id) async {
    final entry = await (db.select(
      db.ingredientsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (entry == null) return null;

    final allergensList = List<String>.from(
      jsonDecode(entry.allergens) as List<dynamic>,
    );
    return Ingredient(
      id: entry.id,
      nameAr: entry.nameAr,
      nameEn: entry.nameEn,
      category: entry.category,
      allergens: allergensList,
      commonInRegion: entry.commonInRegion,
    );
  }

  Future<void> insertIngredients(List<Ingredient> ingredients) async {
    await db.transaction(() async {
      for (final ing in ingredients) {
        await db
            .into(db.ingredientsTable)
            .insertOnConflictUpdate(
              IngredientEntry(
                id: ing.id,
                nameAr: ing.nameAr,
                nameEn: ing.nameEn,
                category: ing.category,
                allergens: jsonEncode(ing.allergens),
                commonInRegion: ing.commonInRegion,
              ),
            );
      }
    });
  }

  Future<int> countIngredients() async {
    final countExp = db.ingredientsTable.id.count();
    final query = db.selectOnly(db.ingredientsTable)..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}

/// DAO for KidProfile persistence
class KidProfilesDao {
  KidProfilesDao(this.db);
  final AppDatabase db;

  Future<List<KidProfile>> getAllProfiles() async {
    final entries = await db.select(db.kidProfilesTable).get();
    return entries.map((e) {
      return KidProfile(
        id: e.id,
        name: e.name,
        birthDate: e.birthDate,
        allergies: List<String>.from(jsonDecode(e.allergies) as List<dynamic>),
        dislikes: List<String>.from(jsonDecode(e.dislikes) as List<dynamic>),
        likes: List<String>.from(jsonDecode(e.likes) as List<dynamic>),
        pickyLevel: e.pickyLevel,
        lunchboxType: e.lunchboxType,
        notes: e.notes,
      );
    }).toList();
  }

  Future<void> insertProfile(KidProfile profile) async {
    await db
        .into(db.kidProfilesTable)
        .insertOnConflictUpdate(
          KidProfileEntry(
            id: profile.id,
            name: profile.name,
            birthDate: profile.birthDate,
            allergies: jsonEncode(profile.allergies),
            dislikes: jsonEncode(profile.dislikes),
            likes: jsonEncode(profile.likes),
            pickyLevel: profile.pickyLevel,
            lunchboxType: profile.lunchboxType,
            notes: profile.notes,
          ),
        );
  }

  Future<void> deleteProfile(String id) async {
    await (db.delete(
      db.kidProfilesTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}

/// DAO for GroceryItem management
class GroceryDao {
  GroceryDao(this.db);
  final AppDatabase db;

  Future<List<GroceryItem>> getAllItems() async {
    final entries = await db.select(db.groceryItemsTable).get();
    return entries.map((e) {
      return GroceryItem(
        id: e.id,
        ingredientId: e.ingredientId,
        nameAr: e.nameAr,
        nameEn: e.nameEn,
        aisle: e.aisle,
        quantity: e.quantity,
        unit: e.unit,
        isChecked: e.isChecked,
        recipeId: e.recipeId,
      );
    }).toList();
  }

  Future<void> insertItem(GroceryItem item) async {
    await db
        .into(db.groceryItemsTable)
        .insertOnConflictUpdate(
          GroceryItemEntry(
            id: item.id,
            ingredientId: item.ingredientId,
            nameAr: item.nameAr,
            nameEn: item.nameEn,
            aisle: item.aisle,
            quantity: item.quantity,
            unit: item.unit,
            isChecked: item.isChecked,
            recipeId: item.recipeId,
          ),
        );
  }

  Future<void> toggleItem(String id, bool isChecked) async {
    await (db.update(db.groceryItemsTable)..where((tbl) => tbl.id.equals(id)))
        .write(GroceryItemsTableCompanion(isChecked: Value(isChecked)));
  }

  Future<void> deleteItem(String id) async {
    await (db.delete(
      db.groceryItemsTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}

/// DAO for MealFeedback tracking
class FeedbackDao {
  FeedbackDao(this.db);
  final AppDatabase db;

  Future<List<MealFeedback>> getAllFeedback() async {
    final entries = await (db.select(
      db.mealFeedbacksTable,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])).get();
    return entries.map((e) {
      return MealFeedback(
        id: e.id,
        recipeId: e.recipeId,
        kidId: e.kidId,
        reaction: e.reaction,
        reasonTag: e.reasonTag,
        date: e.date,
        notes: e.notes,
      );
    }).toList();
  }

  Stream<List<MealFeedback>> watchAllFeedback() {
    final query = db.select(db.mealFeedbacksTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    return query.watch().map((entries) {
      return entries.map((e) {
        return MealFeedback(
          id: e.id,
          recipeId: e.recipeId,
          kidId: e.kidId,
          reaction: e.reaction,
          reasonTag: e.reasonTag,
          date: e.date,
          notes: e.notes,
        );
      }).toList();
    });
  }

  Future<void> insertFeedback(MealFeedback feedback) async {
    await db
        .into(db.mealFeedbacksTable)
        .insertOnConflictUpdate(
          MealFeedbackEntry(
            id: feedback.id,
            recipeId: feedback.recipeId,
            kidId: feedback.kidId,
            reaction: feedback.reaction,
            reasonTag: feedback.reasonTag,
            date: feedback.date,
            notes: feedback.notes,
          ),
        );
  }

  Future<void> deleteFeedback(String id) async {
    await (db.delete(
      db.mealFeedbacksTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}

/// DAO for AppMetadata (seed version, config flags)
class AppMetadataDao {
  AppMetadataDao(this.db);
  final AppDatabase db;

  Future<String?> getValue(String key) async {
    final entry = await (db.select(
      db.appMetadataTable,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return entry?.value;
  }

  Future<void> setValue(String key, String value) async {
    await db
        .into(db.appMetadataTable)
        .insertOnConflictUpdate(AppMetadataEntry(key: key, value: value));
  }
}
