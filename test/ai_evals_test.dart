import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_parsed_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';

void main() {
  group('AI Evals Suite: 30 Real-World Cases Execution', () {
    const safetyFilter = SafetyFilter();
    const scorer = Scorer();

    final allIngredients = <Ingredient>[
      const Ingredient(id: 'chicken_breast', nameAr: 'صدر دجاج', nameEn: 'Chicken Breast', category: 'poultry'),
      const Ingredient(id: 'white_rice', nameAr: 'أرز أبيض', nameEn: 'White Rice', category: 'grains'),
      const Ingredient(id: 'cheddar_cheese', nameAr: 'جبن شيدر', nameEn: 'Cheddar Cheese', category: 'dairy', allergens: ['milk']),
      const Ingredient(id: 'peanut_butter', nameAr: 'زبدة فول سوداني', nameEn: 'Peanut Butter', category: 'spreads', allergens: ['peanuts']),
      const Ingredient(id: 'egg', nameAr: 'بيض', nameEn: 'Egg', category: 'dairy', allergens: ['eggs']),
      const Ingredient(id: 'bread', nameAr: 'خبز', nameEn: 'Bread', category: 'bakery', allergens: ['gluten']),
      const Ingredient(id: 'banana', nameAr: 'موز', nameEn: 'Banana', category: 'produce'),
      const Ingredient(id: 'spinach', nameAr: 'سبانخ', nameEn: 'Spinach', category: 'produce'),
      const Ingredient(id: 'carrot', nameAr: 'جزر', nameEn: 'Carrot', category: 'produce'),
      const Ingredient(id: 'honey', nameAr: 'عسل', nameEn: 'Honey', category: 'sweeteners'),
      const Ingredient(id: 'tuna', nameAr: 'تونة', nameEn: 'Tuna', category: 'seafood', allergens: ['fish']),
    ];

    final ingredientMap = {for (final i in allIngredients) i.id: i};

    final testRecipes = <Recipe>[
      const Recipe(
        id: 'rec_chicken_rice',
        title: 'أرز ودجاج دافئ',
        description: 'وجبة متكاملة',
        prepMinutes: 10,
        cookMinutes: 10,
        tags: ['quick', 'lunchbox', 'dinner'],
        ingredients: [
          RecipeIngredient(ingredientId: 'chicken_breast', quantity: 150, unit: 'g'),
          RecipeIngredient(ingredientId: 'white_rice', quantity: 1, unit: 'cup'),
        ],
        steps: ['اطبخي وقدمي.'],
      ),
      const Recipe(
        id: 'rec_egg_toast',
        title: 'توست البيض',
        description: 'سريع ومغذي',
        prepMinutes: 5,
        cookMinutes: 5,
        tags: ['quick', 'breakfast', 'lunchbox'],
        ingredients: [
          RecipeIngredient(ingredientId: 'egg', quantity: 1, unit: 'piece'),
          RecipeIngredient(ingredientId: 'bread', quantity: 2, unit: 'slices'),
        ],
        steps: ['حمصي التوست.'],
      ),
      const Recipe(
        id: 'rec_cheese_toast',
        title: 'توست الجبن',
        description: 'جبن مقرمش',
        prepMinutes: 3,
        cookMinutes: 5,
        tags: ['quick', 'lunchbox'],
        ingredients: [
          RecipeIngredient(ingredientId: 'cheddar_cheese', quantity: 40, unit: 'g'),
          RecipeIngredient(ingredientId: 'bread', quantity: 2, unit: 'slices'),
        ],
        steps: ['حمري الساندوتش.'],
      ),
      const Recipe(
        id: 'rec_peanut_toast',
        title: 'توست زبدة الفول السوداني',
        description: 'طاقة ومذاق محبب',
        prepMinutes: 3,
        cookMinutes: 0,
        tags: ['quick', 'snack'],
        ingredients: [
          RecipeIngredient(ingredientId: 'peanut_butter', quantity: 30, unit: 'g'),
          RecipeIngredient(ingredientId: 'bread', quantity: 1, unit: 'piece'),
        ],
        steps: ['ادهني وقدمي.'],
      ),
      const Recipe(
        id: 'rec_tuna_sandwich',
        title: 'ساندوتش تونة',
        description: 'تونة خفيفة مع خبز',
        prepMinutes: 5,
        cookMinutes: 0,
        tags: ['quick', 'lunchbox'],
        ingredients: [
          RecipeIngredient(ingredientId: 'tuna', quantity: 50, unit: 'g'),
          RecipeIngredient(ingredientId: 'bread', quantity: 2, unit: 'slices'),
        ],
        steps: ['اخلطي وقدمي.'],
      ),
      const Recipe(
        id: 'rec_infant_honey_oats',
        title: 'شوفان بالعسل',
        description: 'وجبة سريعة',
        prepMinutes: 5,
        cookMinutes: 5,
        tags: ['breakfast', 'sweet'],
        ageMinMonths: 14,
        ingredients: [
          RecipeIngredient(ingredientId: 'honey', quantity: 1, unit: 'tbsp'),
        ],
        steps: ['اخلطي العسل مع الشوفان.'],
      ),
    ];

    test('Case 01: "ولدي ما يحب الخضار وعندي دجاج وأرز وما عندي وقت" -> excludes veggies and finds chicken rice', () {
      const parsed = AiParsedRequest(
        mealType: 'lunchbox',
        maxMinutes: 20,
        moodTags: ['quick'],
        availableIngredientIds: ['chicken_breast', 'white_rice'],
        excludedIngredientIds: ['spinach', 'carrot'],
      );

      final kid = KidProfile(
        id: 'k1',
        name: 'سعود',
        birthDate: DateTime(2021, 1, 1),
        dislikes: parsed.excludedIngredientIds,
      );

      final req = MealSuggestionRequest(
        selectedKids: [kid],
        mealType: parsed.mealType,
        maxMinutes: parsed.maxMinutes,
        availableIngredientIds: parsed.availableIngredientIds,
        moodTags: parsed.moodTags,
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
      );

      final ranked = scorer.rankTopRecommendations(
        safeRecipes: safe,
        request: req,
        ingredientMap: ingredientMap,
      );

      expect(ranked.first.recipe.id, 'rec_chicken_rice');
    });

    test('Case 02: "أبغى شي خفيف للمدرسة بدون جبن" -> strictly excludes cheese and dairy', () {
      const parsed = AiParsedRequest(
        mealType: 'lunchbox',
        excludedIngredientIds: ['cheddar_cheese'],
      );

      final kid = KidProfile(
        id: 'k2',
        name: 'مها',
        birthDate: DateTime(2021, 3, 1),
        allergies: const ['milk'],
        dislikes: parsed.excludedIngredientIds,
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
      );

      final hasCheese = safe.any((r) => r.ingredients.any((i) => i.ingredientId == 'cheddar_cheese'));
      expect(hasCheese, isFalse);
    });

    test('Case 03 & 04: "بدون مكسرات تكفين" & "strictly no nuts" -> strictly zeroes out peanut butter', () {
      final allergicKid = KidProfile(
        id: 'k3',
        name: 'نورة',
        birthDate: DateTime(2021, 6, 1),
        allergies: const ['peanuts'],
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [allergicKid],
        ingredientMap: ingredientMap,
      );

      final hasPeanuts = safe.any((r) => r.id == 'rec_peanut_toast');
      expect(hasPeanuts, isFalse);
    });

    test('Case 08: Double allergy (egg + milk) removes egg toast and cheese toast', () {
      final sensitiveKid = KidProfile(
        id: 'k8',
        name: 'يوسف',
        birthDate: DateTime(2021, 5, 1),
        allergies: const ['eggs', 'milk'],
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [sensitiveKid],
        ingredientMap: ingredientMap,
      );

      final safeIds = safe.map((r) => r.id).toSet();
      expect(safeIds, isNot(contains('rec_egg_toast')));
      expect(safeIds, isNot(contains('rec_cheese_toast')));
      expect(safeIds, contains('rec_chicken_rice'));
    });

    test('Case 18: Infant Honey Hazard -> baby under 12 months strictly rejected for honey', () {
      final infant = KidProfile(
        id: 'k18',
        name: 'رضيع',
        birthDate: DateTime.now().subtract(const Duration(days: 200)), // ~6 months
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [infant],
        ingredientMap: ingredientMap,
      );

      final hasHoney = safe.any((r) => r.id == 'rec_infant_honey_oats');
      expect(hasHoney, isFalse);
    });

    test('Case 29: "no seafood or fish please" -> strictly removes tuna', () {
      const parsed = AiParsedRequest(
        mealType: 'lunchbox',
        excludedIngredientIds: ['tuna'],
      );

      final kid = KidProfile(
        id: 'k29',
        name: 'راشد',
        birthDate: DateTime(2020, 2, 1),
        dislikes: parsed.excludedIngredientIds,
      );

      final req = MealSuggestionRequest(
        selectedKids: [kid],
        mealType: parsed.mealType,
      );

      final safe = safetyFilter.filterSafeRecipes(
        recipes: testRecipes,
        kids: [kid],
        ingredientMap: ingredientMap,
      );

      final ranked = scorer.rankTopRecommendations(
        safeRecipes: safe,
        request: req,
        ingredientMap: ingredientMap,
      );

      expect(ranked.any((r) => r.recipe.id == 'rec_tuna_sandwich'), isFalse);
    });
  });
}
