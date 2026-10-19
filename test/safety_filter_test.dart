import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, Ingredient> ingredientMap;
  late List<Recipe> curatedRecipes;
  const safetyFilter = SafetyFilter();

  final refDate = DateTime(2026, 10, 19);

  KidProfile createKid({
    String id = 'test_kid',
    String name = 'Test Kid',
    int ageMonths = 48,
    List<String> allergies = const [],
    List<String> dislikes = const [],
  }) {
    final birthDate = DateTime(
      refDate.year - (ageMonths ~/ 12),
      refDate.month - (ageMonths % 12),
      refDate.day,
    );
    return KidProfile(
      id: id,
      name: name,
      birthDate: birthDate,
      allergies: allergies,
      dislikes: dislikes,
    );
  }

  setUpAll(() {
    final ingredientsJson = File('assets/data/ingredients.json')
        .readAsStringSync();
    final recipesJson = File('assets/data/recipes.json').readAsStringSync();

    final ingredientsList = (jsonDecode(ingredientsJson) as List<dynamic>)
        .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
        .toList();

    ingredientMap = {for (final ing in ingredientsList) ing.id: ing};

    curatedRecipes = (jsonDecode(recipesJson) as List<dynamic>)
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  });

  group('SafetyFilter Unit Tests (20 Comprehensive Cases)', () {
    // -------------------------------------------------------------------------
    // Case 1: Milk Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 1: Milk allergy removes all milk-containing recipes', () {
      final kid = createKid(allergies: ['milk']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('milk') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains milk ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 2: Egg Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 2: Egg allergy removes all egg-containing recipes', () {
      final kid = createKid(allergies: ['egg']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('egg') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains egg ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 3: Gluten Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 3: Gluten allergy removes all gluten/wheat-containing recipes', () {
      final kid = createKid(allergies: ['gluten']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('gluten') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains gluten ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 4: Peanut Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 4: Peanut allergy removes all peanut-containing recipes', () {
      final kid = createKid(allergies: ['peanut']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            (ingredient?.allergens.contains('peanuts') ?? false) ||
                (ingredient?.allergens.contains('peanut') ?? false),
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains peanut ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 5: Tree Nut Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 5: Tree nut allergy removes all nut-containing recipes', () {
      final kid = createKid(allergies: ['treenut']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            (ingredient?.allergens.contains('nuts') ?? false) ||
                (ingredient?.allergens.contains('treenut') ?? false),
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains tree nut ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 6: ACCEPTANCE CRITERIA - Given a nut-allergic kid, no recipe containing
    // nuts or peanuts ever appears
    // -------------------------------------------------------------------------
    test('Case 6 (ACCEPTANCE): Nut-allergic kid never sees recipes with nuts or peanuts', () {
      for (final nutAllergyVariant in [
        'nuts',
        'treenut',
        'peanut',
        'peanuts',
      ]) {
        final kid = createKid(allergies: [nutAllergyVariant]);
        final safeRecipes = safetyFilter.filterSafeRecipes(
          recipes: curatedRecipes,
          kids: [kid],
          ingredientMap: ingredientMap,
          referenceDate: refDate,
        );

        expect(safeRecipes.isNotEmpty, isTrue);

        for (final recipe in safeRecipes) {
          for (final ing in recipe.ingredients) {
            final ingredient = ingredientMap[ing.ingredientId];
            final allergens = ingredient?.allergens ?? const [];

            expect(
              allergens.contains('peanuts') ||
                  allergens.contains('peanut') ||
                  allergens.contains('nuts') ||
                  allergens.contains('treenut'),
              isFalse,
              reason:
                  'Nut-allergic kid ($nutAllergyVariant) got recipe "${recipe.id}" containing ${ing.ingredientId} ($allergens)',
            );
          }
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 7: Sesame Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 7: Sesame allergy removes tahini, zaatar and sesame recipes', () {
      final kid = createKid(allergies: ['sesame']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('sesame') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains sesame ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 8: Fish Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 8: Fish allergy removes tuna and fish recipes', () {
      final kid = createKid(allergies: ['fish']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('fish') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains fish ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 9: Shellfish Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 9: Shellfish allergy removes shellfish/shrimp recipes', () {
      final kid = createKid(allergies: ['shellfish']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('shellfish') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains shellfish ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 10: Soy Allergen Filtering
    // -------------------------------------------------------------------------
    test('Case 10: Soy allergy removes soy-containing recipes', () {
      final kid = createKid(allergies: ['soy']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final ingredient = ingredientMap[ing.ingredientId];
          expect(
            ingredient?.allergens.contains('soy') ?? false,
            isFalse,
            reason:
                'Recipe "${recipe.id}" contains soy ingredient: ${ing.ingredientId}',
          );
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 11: Empty Allergies (No Allergies)
    // -------------------------------------------------------------------------
    test('Case 11: Kid with empty allergies passes allergen filter', () {
      final kid = createKid(allergies: []);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      // Only recipes filtered are those failing age guidance for this 48mo kid
      expect(safeRecipes.length, equals(curatedRecipes.length));
    });

    // -------------------------------------------------------------------------
    // Case 12: Multiple Kids with Different Allergies (Milk + Egg)
    // -------------------------------------------------------------------------
    test('Case 12: Multiple kids (Kid A: milk, Kid B: egg) removes both', () {
      final kidA = createKid(id: 'kid_a', name: 'Kid A', allergies: ['milk']);
      final kidB = createKid(id: 'kid_b', name: 'Kid B', allergies: ['egg']);

      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kidA, kidB],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final allergens = ingredientMap[ing.ingredientId]?.allergens ?? [];
          expect(allergens.contains('milk'), isFalse);
          expect(allergens.contains('egg'), isFalse);
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 13: Multiple Kids (Gluten + Peanuts + Sesame)
    // -------------------------------------------------------------------------
    test(
      'Case 13: Multiple kids (gluten, peanut, sesame) removes all three',
      () {
        final kidA = createKid(id: 'a', allergies: ['gluten']);
        final kidB = createKid(id: 'b', allergies: ['peanut']);
        final kidC = createKid(id: 'c', allergies: ['sesame']);

        final safeRecipes = safetyFilter.filterSafeRecipes(
          recipes: curatedRecipes,
          kids: [kidA, kidB, kidC],
          ingredientMap: ingredientMap,
          referenceDate: refDate,
        );

        for (final recipe in safeRecipes) {
          for (final ing in recipe.ingredients) {
            final allergens = ingredientMap[ing.ingredientId]?.allergens ?? [];
            expect(allergens.contains('gluten'), isFalse);
            expect(allergens.contains('peanuts'), isFalse);
            expect(allergens.contains('sesame'), isFalse);
          }
        }
      },
    );

    // -------------------------------------------------------------------------
    // Case 14: Single Kid with Multiple Allergies
    // -------------------------------------------------------------------------
    test('Case 14: Single kid with multiple allergies (milk, fish, egg)', () {
      final kid = createKid(allergies: ['milk', 'fish', 'egg']);
      final safeRecipes = safetyFilter.filterSafeRecipes(
        recipes: curatedRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      for (final recipe in safeRecipes) {
        for (final ing in recipe.ingredients) {
          final allergens = ingredientMap[ing.ingredientId]?.allergens ?? [];
          expect(allergens.contains('milk'), isFalse);
          expect(allergens.contains('fish'), isFalse);
          expect(allergens.contains('egg'), isFalse);
        }
      }
    });

    // -------------------------------------------------------------------------
    // Case 15: Age Guidance - Infant Below Minimum Age
    // -------------------------------------------------------------------------
    test(
      'Case 15: Infant aged 6 months filters out recipes with ageMinMonths > 6',
      () {
        final infant = createKid(ageMonths: 6);
        const recipeForOlderKids = Recipe(
          id: 'crunchy_carrot_salad',
          title: 'سلطة جزر مقرمشة',
          description: 'جزر مقطع شرائح سميكة',
          ingredients: [RecipeIngredient(ingredientId: 'carrot')],
          steps: ['قطع الجزر وقدمه'],
          prepMinutes: 5,
          cookMinutes: 0,
          ageMinMonths: 18,
        );

        final result = safetyFilter.checkRecipe(
          recipe: recipeForOlderKids,
          kids: [infant],
          ingredientMap: ingredientMap,
          referenceDate: refDate,
        );

        expect(result.isSafe, isFalse);
        expect(result.rejectionReasons.first, contains('exceeds child age'));
      },
    );

    // -------------------------------------------------------------------------
    // Case 16: Age Guidance - Honey strictly forbidden under 12 months (Botulism)
    // -------------------------------------------------------------------------
    test('Case 16: Infant under 12 months strictly forbids honey', () {
      final infant = createKid(ageMonths: 10);
      const honeyRecipe = Recipe(
        id: 'honey_oat_treat',
        title: 'شوفان بالعسل',
        description: 'شوفان دافئ مع ملعقة عسل',
        ingredients: [
          RecipeIngredient(ingredientId: 'oats'),
          RecipeIngredient(ingredientId: 'honey'),
        ],
        steps: ['اخلط وقدم'],
        prepMinutes: 5,
        cookMinutes: 5,
        ageMinMonths: 6, // Even if recipe says 6m, safety rule overrides!
      );

      final result = safetyFilter.checkRecipe(
        recipe: honeyRecipe,
        kids: [infant],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      expect(result.isSafe, isFalse);
      expect(
        result.rejectionReasons.any(
          (r) => r.contains('Honey is strictly forbidden'),
        ),
        isTrue,
      );
    });

    // -------------------------------------------------------------------------
    // Case 17: Age Guidance - Whole nuts choking hazard for toddlers < 36 months
    // -------------------------------------------------------------------------
    test('Case 17: Toddlers under 36 months strictly forbid whole nuts', () {
      final toddler = createKid(ageMonths: 24);
      const wholeNutsRecipe = Recipe(
        id: 'almond_crunch',
        title: 'وجبة اللوز',
        description: 'لوز كامل',
        ingredients: [RecipeIngredient(ingredientId: 'almonds')],
        steps: ['قدم اللوز'],
        prepMinutes: 2,
        cookMinutes: 0,
        ageMinMonths: 12,
      );

      final result = safetyFilter.checkRecipe(
        recipe: wholeNutsRecipe,
        kids: [toddler],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      expect(result.isSafe, isFalse);
      expect(
        result.rejectionReasons.any((r) => r.contains('choking hazard')),
        isTrue,
      );
    });

    // -------------------------------------------------------------------------
    // Case 18: Youngest Child Determines Safety Threshold in Multi-Child Family
    // -------------------------------------------------------------------------
    test('Case 18: Youngest child (infant + 6yo child) governs safety', () {
      final infant = createKid(id: 'infant', ageMonths: 8);
      final olderKid = createKid(id: 'older', ageMonths: 72);

      const honeyRecipe = Recipe(
        id: 'honey_pancake',
        title: 'بان كيك بالعسل',
        description: 'بان كيك مع عسل',
        ingredients: [RecipeIngredient(ingredientId: 'honey')],
        steps: ['اخلط'],
        prepMinutes: 5,
        cookMinutes: 5,
        ageMinMonths: 6,
      );

      final result = safetyFilter.checkRecipe(
        recipe: honeyRecipe,
        kids: [olderKid, infant],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      expect(result.isSafe, isFalse);
    });

    // -------------------------------------------------------------------------
    // Case 19: Pure Safe Recipe Passes All Checks
    // -------------------------------------------------------------------------
    test('Case 19: Safe allergen-free recipe passes for all kids', () {
      final kid = createKid(allergies: ['milk', 'nuts', 'gluten']);
      const safeAppleRecipe = Recipe(
        id: 'apple_banana_snack',
        title: 'تفاح وموز',
        description: 'شرائح تفاح وموز طازج',
        ingredients: [
          RecipeIngredient(ingredientId: 'apple'),
          RecipeIngredient(ingredientId: 'banana'),
        ],
        steps: ['قطع وقدم'],
        prepMinutes: 3,
        cookMinutes: 0,
        ageMinMonths: 12,
      );

      final result = safetyFilter.checkRecipe(
        recipe: safeAppleRecipe,
        kids: [kid],
        ingredientMap: ingredientMap,
        referenceDate: refDate,
      );

      expect(result.isSafe, isTrue);
      expect(result.rejectionReasons, isEmpty);
    });

    // -------------------------------------------------------------------------
    // Case 20: Deterministic Execution
    // -------------------------------------------------------------------------
    test(
      'Case 20: Results are strictly deterministic across multiple runs',
      () {
        final kid = createKid(allergies: ['gluten', 'egg']);

        final run1 = safetyFilter.filterSafeRecipes(
          recipes: curatedRecipes,
          kids: [kid],
          ingredientMap: ingredientMap,
          referenceDate: refDate,
        );

        final run2 = safetyFilter.filterSafeRecipes(
          recipes: curatedRecipes,
          kids: [kid],
          ingredientMap: ingredientMap,
          referenceDate: refDate,
        );

        expect(
          run1.map((r) => r.id).toList(),
          equals(run2.map((r) => r.id).toList()),
        );
      },
    );
  });
}
