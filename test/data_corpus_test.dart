import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/services/seed_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String ingredientsJsonString;
  late String recipesJsonString;
  late List<Ingredient> ingredients;
  late List<Recipe> recipes;

  setUpAll(() {
    // Read JSON assets from filesystem for unit tests
    ingredientsJsonString = File('assets/data/ingredients.json')
        .readAsStringSync();
    recipesJsonString = File('assets/data/recipes.json').readAsStringSync();

    ingredients = (jsonDecode(ingredientsJsonString) as List<dynamic>)
        .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
        .toList();

    recipes = (jsonDecode(recipesJsonString) as List<dynamic>)
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  });

  group('Curated Recipe & Ingredient Corpus Integrity', () {
    test('ingredients.json has unique IDs and valid entries', () {
      expect(ingredients.isNotEmpty, isTrue);
      final idSet = <String>{};

      for (final ing in ingredients) {
        expect(ing.id.trim().isNotEmpty, isTrue);
        expect(ing.nameAr.trim().isNotEmpty, isTrue);
        expect(ing.nameEn.trim().isNotEmpty, isTrue);
        expect(ing.category.trim().isNotEmpty, isTrue);
        expect(
          idSet.add(ing.id),
          isTrue,
          reason: 'Duplicate ingredient id found: ${ing.id}',
        );
      }
    });

    test('recipes.json contains 38+ recipes', () {
      expect(recipes.length, greaterThanOrEqualTo(38));
    });

    test('every recipe ingredient id exists in ingredients.json', () {
      final validIngredientIds = ingredients.map((i) => i.id).toSet();

      for (final recipe in recipes) {
        expect(
          recipe.ingredients.isNotEmpty,
          isTrue,
          reason: 'Recipe ${recipe.id} has no ingredients defined',
        );

        for (final recipeIng in recipe.ingredients) {
          expect(
            validIngredientIds.contains(recipeIng.ingredientId),
            isTrue,
            reason:
                'Ingredient "${recipeIng.ingredientId}" in recipe "${recipe.id}" does not exist in ingredients.json',
          );
        }
      }
    });

    test('no recipe has an empty step list or blank step text', () {
      for (final recipe in recipes) {
        expect(
          recipe.steps.isNotEmpty,
          isTrue,
          reason: 'Recipe ${recipe.id} has an empty steps list',
        );

        for (final step in recipe.steps) {
          expect(
            step.trim().isNotEmpty,
            isTrue,
            reason: 'Recipe ${recipe.id} contains a blank step',
          );
        }
      }
    });

    test('all recipes strictly adhere to halal standards', () {
      final forbiddenKeywords = [
        'pork',
        'خنزير',
        'bacon',
        'ham',
        'alcohol',
        'كحول',
        'wine',
        'beer',
        'خمور',
      ];

      for (final recipe in recipes) {
        final content =
            '${recipe.title} ${recipe.description} '
                    '${recipe.steps.join(' ')}'
                .toLowerCase();

        for (final forbidden in forbiddenKeywords) {
          expect(
            content.contains(forbidden),
            isFalse,
            reason:
                'Forbidden ingredient/term "$forbidden" detected in recipe "${recipe.id}"',
          );
        }
      }
    });
  });

  group('Drift Database and DAOs', () {
    late AppDatabase db;
    late IngredientsDao ingredientsDao;
    late RecipesDao recipesDao;
    late KidProfilesDao kidProfilesDao;
    late GroceryDao groceryDao;
    late FeedbackDao feedbackDao;

    setUp(() {
      // Create in-memory database for testing
      db = AppDatabase(NativeDatabase.memory());
      ingredientsDao = IngredientsDao(db);
      recipesDao = RecipesDao(db);
      kidProfilesDao = KidProfilesDao(db);
      groceryDao = GroceryDao(db);
      feedbackDao = FeedbackDao(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('inserts and retrieves ingredients successfully', () async {
      await ingredientsDao.insertIngredients(ingredients);
      final stored = await ingredientsDao.getAllIngredients();

      expect(stored.length, equals(ingredients.length));

      final single = await ingredientsDao.getIngredientById('chicken');
      expect(single, isNotNull);
      expect(single!.nameAr, contains('دجاج'));
    });

    test(
      'inserts and retrieves recipes with constituent ingredients',
      () async {
        await ingredientsDao.insertIngredients(ingredients);
        await recipesDao.insertRecipes(recipes);

        final storedRecipes = await recipesDao.getAllRecipes();
        expect(storedRecipes.length, equals(recipes.length));

        final sample = await recipesDao.getRecipeById('labneh_cucumber');
        expect(sample, isNotNull);
        expect(sample!.title, contains('لبنة'));
        expect(sample.ingredients.length, greaterThanOrEqualTo(3));
        expect(sample.steps.length, greaterThanOrEqualTo(2));
      },
    );

    test('kid profiles CRUD works as expected', () async {
      final profile = KidProfile(
        id: 'kid_1',
        name: 'سارة',
        birthDate: DateTime(2018, 5, 12),
        allergies: ['egg'],
        dislikes: ['cucumber'],
        likes: ['chicken', 'apple'],
        pickyLevel: 2,
        lunchboxType: 'cold',
      );

      await kidProfilesDao.insertProfile(profile);
      final profiles = await kidProfilesDao.getAllProfiles();
      expect(profiles.length, equals(1));
      expect(profiles.first.name, equals('سارة'));
      expect(profiles.first.allergies, contains('egg'));

      await kidProfilesDao.deleteProfile('kid_1');
      final remaining = await kidProfilesDao.getAllProfiles();
      expect(remaining.isEmpty, isTrue);
    });

    test('grocery items toggle and deletion work as expected', () async {
      const item = GroceryItem(
        id: 'g_1',
        ingredientId: 'chicken',
        nameAr: 'صدر دجاج',
        nameEn: 'Chicken Breast',
        aisle: 'protein',
        quantity: 500,
        unit: 'grams',
        isChecked: false,
      );

      await groceryDao.insertItem(item);
      final items = await groceryDao.getAllItems();
      expect(items.length, equals(1));
      expect(items.first.isChecked, isFalse);

      await groceryDao.toggleItem('g_1', true);
      final updated = await groceryDao.getAllItems();
      expect(updated.first.isChecked, isTrue);

      await groceryDao.deleteItem('g_1');
      final empty = await groceryDao.getAllItems();
      expect(empty.isEmpty, isTrue);
    });

    test('meal feedback can be stored and retrieved', () async {
      final feedback = MealFeedback(
        id: 'fb_1',
        recipeId: 'labneh_cucumber',
        kidId: 'kid_1',
        reaction: 'loved',
        reasonTag: 'crunchy',
        date: DateTime.now(),
        notes: 'أكلت الساندوتش كامل',
      );

      await feedbackDao.insertFeedback(feedback);
      final stored = await feedbackDao.getAllFeedback();
      expect(stored.length, equals(1));
      expect(stored.first.reaction, equals('loved'));
    });
  });

  group('SeedService Idempotency and Versioning', () {
    late AppDatabase db;
    late SeedService seedService;
    late RecipesDao recipesDao;
    late IngredientsDao ingredientsDao;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      recipesDao = RecipesDao(db);
      ingredientsDao = IngredientsDao(db);
      seedService = SeedService(db: db);
    });

    tearDown(() async {
      await db.close();
    });

    test('initial seed populates database and marks version', () async {
      final seeded = await seedService.seedIfNeeded(
        ingredientsJsonString: ingredientsJsonString,
        recipesJsonString: recipesJsonString,
      );

      expect(seeded, isTrue);
      final recipeCount = await recipesDao.countRecipes();
      final ingredientCount = await ingredientsDao.countIngredients();

      expect(recipeCount, equals(recipes.length));
      expect(ingredientCount, equals(ingredients.length));

      // Second call without force should skip seeding (idempotent)
      final secondCallSeeded = await seedService.seedIfNeeded(
        ingredientsJsonString: ingredientsJsonString,
        recipesJsonString: recipesJsonString,
      );

      expect(secondCallSeeded, isFalse);

      final countAfterSecond = await recipesDao.countRecipes();
      expect(countAfterSecond, equals(recipes.length));
    });

    test('force re-seed cleanly refreshes data without conflict', () async {
      await seedService.seedIfNeeded(
        ingredientsJsonString: ingredientsJsonString,
        recipesJsonString: recipesJsonString,
      );

      // Force re-seed
      await seedService.forceReSeed(
        ingredientsJsonString: ingredientsJsonString,
        recipesJsonString: recipesJsonString,
      );

      final count = await recipesDao.countRecipes();
      expect(count, equals(recipes.length));
    });
  });
}
