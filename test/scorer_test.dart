import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';

void main() {
  const scorer = Scorer();
  final refDate = DateTime(2026, 10, 19, 12, 0);

  final testIngredients = <String, Ingredient>{
    'bread': const Ingredient(
      id: 'bread',
      nameAr: 'خبز',
      nameEn: 'Bread',
      category: 'bakery',
      allergens: ['gluten'],
    ),
    'cheese': const Ingredient(
      id: 'cheese',
      nameAr: 'جبن',
      nameEn: 'Cheese',
      category: 'dairy',
      allergens: ['milk'],
    ),
    'cucumber': const Ingredient(
      id: 'cucumber',
      nameAr: 'خيار',
      nameEn: 'Cucumber',
      category: 'produce',
    ),
    'tomato': const Ingredient(
      id: 'tomato',
      nameAr: 'طماطم',
      nameEn: 'Tomato',
      category: 'produce',
    ),
    'apple': const Ingredient(
      id: 'apple',
      nameAr: 'تفاح',
      nameEn: 'Apple',
      category: 'produce',
    ),
    'carrot': const Ingredient(
      id: 'carrot',
      nameAr: 'جزر',
      nameEn: 'Carrot',
      category: 'produce',
    ),
  };

  final testRecipes = [
    const Recipe(
      id: 'quick_cheese_sandwich',
      title: 'ساندوتش جبنة وخيار',
      description: 'ساندوتش سريع ولذيذ',
      ingredients: [
        RecipeIngredient(ingredientId: 'bread'),
        RecipeIngredient(ingredientId: 'cheese'),
        RecipeIngredient(ingredientId: 'cucumber'),
      ],
      steps: ['ضع الجبن والخيار في الخبز'],
      prepMinutes: 5,
      cookMinutes: 0,
      tags: ['quick', 'lunchbox-friendly', 'simple'],
    ),
    const Recipe(
      id: 'apple_carrot_plate',
      title: 'طبق التفاح والجزر',
      description: 'خضار وفواكه طازجة',
      ingredients: [
        RecipeIngredient(ingredientId: 'apple'),
        RecipeIngredient(ingredientId: 'carrot'),
      ],
      steps: ['قطع وقدم'],
      prepMinutes: 5,
      cookMinutes: 0,
      tags: ['quick', 'hidden-veggies', 'healthy'],
    ),
    const Recipe(
      id: 'slow_stew',
      title: 'شوربة خضار بطيئة',
      description: 'شوربة تطهى ببطء',
      ingredients: [
        RecipeIngredient(ingredientId: 'carrot'),
        RecipeIngredient(ingredientId: 'tomato'),
      ],
      steps: ['اغلِ الخضار على نار هادئة'],
      prepMinutes: 15,
      cookMinutes: 45,
      tags: ['dinner', 'warm'],
    ),
    const Recipe(
      id: 'tomato_cheese_toast',
      title: 'توست طماطم وجبن',
      description: 'توست مقرمش',
      ingredients: [
        RecipeIngredient(ingredientId: 'bread'),
        RecipeIngredient(ingredientId: 'cheese'),
        RecipeIngredient(ingredientId: 'tomato'),
      ],
      steps: ['حمص التوست'],
      prepMinutes: 10,
      cookMinutes: 5,
      tags: ['lunchbox-friendly', 'breakfast'],
    ),
  ];

  final defaultKid = KidProfile(
    id: 'kid_sarah',
    name: 'سارة',
    birthDate: DateTime(2020, 5, 1),
    allergies: const [],
    dislikes: const [],
    likes: const [],
  );

  group('Scorer Unit Tests with Fixtures', () {
    test('Tag match: recipes matching moodTags and mealType score higher', () {
      final request = MealSuggestionRequest(
        selectedKids: [defaultKid],
        mealType: 'lunchbox',
        moodTags: const ['quick'],
      );

      final recQuickLunchbox = scorer.scoreRecipe(
        recipe: testRecipes[0], // tags: quick, lunchbox-friendly
        request: request,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      final recSlowDinner = scorer.scoreRecipe(
        recipe: testRecipes[2], // tags: dinner, warm
        request: request,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      expect(
        recQuickLunchbox.score,
        greaterThan(recSlowDinner.score),
        reason: 'Quick lunchbox recipe should outscore slow dinner recipe',
      );
      expect(recQuickLunchbox.breakdown['tagMatch']!, greaterThan(0));
    });

    test(
      'Time fit: recipes within maxMinutes score higher than exceeding ones',
      () {
        final request = MealSuggestionRequest(
          selectedKids: [defaultKid],
          maxMinutes: 15,
        );

        final recFast = scorer.scoreRecipe(
          recipe: testRecipes[0], // 5 mins total
          request: request,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );

        final recOverTime = scorer.scoreRecipe(
          recipe: testRecipes[2], // 60 mins total
          request: request,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );

        expect(recFast.breakdown['timeFit']!, greaterThan(0));
        expect(recOverTime.breakdown['timeFit']!, lessThan(0));
        expect(recFast.score, greaterThan(recOverTime.score));
      },
    );

    test('Ingredients on hand ratio adds proportional bonus', () {
      final requestFullMatch = MealSuggestionRequest(
        selectedKids: [defaultKid],
        availableIngredientIds: const ['bread', 'cheese', 'cucumber'],
      );

      final requestNoMatch = MealSuggestionRequest(
        selectedKids: [defaultKid],
        availableIngredientIds: const ['flour', 'milk'],
      );

      final recFull = scorer.scoreRecipe(
        recipe: testRecipes[0],
        request: requestFullMatch,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      final recEmpty = scorer.scoreRecipe(
        recipe: testRecipes[0],
        request: requestNoMatch,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      expect(recFull.breakdown['onHand']!, equals(10.0));
      expect(recEmpty.breakdown['onHand']!, equals(0.0));
      expect(recFull.score - recEmpty.score, equals(10.0));
    });

    test('Kid likes increase score (+2.5 per liked ingredient)', () {
      final kidWithLikes = defaultKid.copyWith(likes: ['cheese', 'apple']);

      final request = MealSuggestionRequest(selectedKids: [kidWithLikes]);

      final recWithCheese = scorer.scoreRecipe(
        recipe: testRecipes[0], // Contains cheese
        request: request,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      expect(recWithCheese.breakdown['likes']!, equals(2.5));
    });

    test('Kid dislikes penalize score (-4.0 per disliked ingredient)', () {
      final kidWithDislikes = defaultKid.copyWith(dislikes: ['cucumber']);

      final request = MealSuggestionRequest(selectedKids: [kidWithDislikes]);

      final recWithCucumber = scorer.scoreRecipe(
        recipe: testRecipes[0], // Contains cucumber
        request: request,
        ingredientMap: testIngredients,
        referenceDate: refDate,
      );

      expect(recWithCucumber.breakdown['dislikes']!, equals(4.0));
    });

    test(
      'Picky kid (pickyLevel >= 2) penalizes dislikes more heavily (-6.0)',
      () {
        final pickyKid = defaultKid.copyWith(
          pickyLevel: 2,
          dislikes: ['cucumber'],
        );

        final request = MealSuggestionRequest(selectedKids: [pickyKid]);

        final rec = scorer.scoreRecipe(
          recipe: testRecipes[0],
          request: request,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );

        expect(rec.breakdown['dislikes']!, equals(6.0));
      },
    );

    test(
      'Recent feedback: refused drops score by 8.0, loved raises by 2.0',
      () {
        final request = MealSuggestionRequest(selectedKids: [defaultKid]);

        final refusedFeedback = [
          MealFeedback(
            id: 'fb1',
            recipeId: testRecipes[0].id,
            reaction: 'refused',
            date: refDate.subtract(const Duration(days: 4)),
          ),
        ];

        final lovedFeedback = [
          MealFeedback(
            id: 'fb2',
            recipeId: testRecipes[0].id,
            reaction: 'loved',
            date: refDate.subtract(const Duration(days: 4)),
          ),
        ];

        final recRefused = scorer.scoreRecipe(
          recipe: testRecipes[0],
          request: request,
          ingredientMap: testIngredients,
          recentFeedbacks: refusedFeedback,
          referenceDate: refDate,
        );

        final recLoved = scorer.scoreRecipe(
          recipe: testRecipes[0],
          request: request,
          ingredientMap: testIngredients,
          recentFeedbacks: lovedFeedback,
          referenceDate: refDate,
        );

        expect(recRefused.breakdown['feedback']!, equals(-8.0));
        expect(recLoved.breakdown['feedback']!, equals(2.0));
        expect(recLoved.score, greaterThan(recRefused.score));
      },
    );

    test('Recent repeat penalty: cooked in last 3 days penalizes -5.0', () {
      final request = MealSuggestionRequest(selectedKids: [defaultKid]);

      final recentRepeatFeedback = [
        MealFeedback(
          id: 'fb_recent',
          recipeId: testRecipes[0].id,
          reaction: 'ok',
          date: refDate.subtract(const Duration(days: 1)),
        ),
      ];

      final rec = scorer.scoreRecipe(
        recipe: testRecipes[0],
        request: request,
        ingredientMap: testIngredients,
        recentFeedbacks: recentRepeatFeedback,
        referenceDate: refDate,
      );

      expect(rec.breakdown['feedback']!, equals(-5.0));
    });

    test(
      'rankTopRecommendations truncates to top 3 and is strictly deterministic',
      () {
        final request = MealSuggestionRequest(
          selectedKids: [defaultKid],
          mealType: 'lunchbox',
          moodTags: const ['quick'],
        );

        final top3Run1 = scorer.rankTopRecommendations(
          safeRecipes: testRecipes,
          request: request,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );

        final top3Run2 = scorer.rankTopRecommendations(
          safeRecipes: testRecipes,
          request: request,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );

        expect(top3Run1.length, equals(3));
        expect(
          top3Run1.map((r) => r.recipe.id).toList(),
          equals(top3Run2.map((r) => r.recipe.id).toList()),
        );
      },
    );

    test(
      'Assigns appropriate one-line reason key based on dominant factor',
      () {
        // 1. Ingredients on hand
        final onHandReq = MealSuggestionRequest(
          selectedKids: [defaultKid],
          availableIngredientIds: const ['bread', 'cheese', 'cucumber'],
        );
        final onHandRec = scorer.scoreRecipe(
          recipe: testRecipes[0],
          request: onHandReq,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );
        expect(onHandRec.reasonKey, equals('reason_ingredients_on_hand'));

        // 2. Kid favorite (liked ingredient)
        final favKid = defaultKid.copyWith(likes: ['apple']);
        final favReq = MealSuggestionRequest(selectedKids: [favKid]);
        final favRec = scorer.scoreRecipe(
          recipe: testRecipes[1], // apple & carrot
          request: favReq,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );
        expect(favRec.reasonKey, equals('reason_kid_favorite'));

        // 3. Hidden veggies for picky child
        final pickyKid = defaultKid.copyWith(pickyLevel: 2);
        final pickyReq = MealSuggestionRequest(selectedKids: [pickyKid]);
        final hiddenVegRec = scorer.scoreRecipe(
          recipe: testRecipes[1], // tags: hidden-veggies
          request: pickyReq,
          ingredientMap: testIngredients,
          referenceDate: refDate,
        );
        expect(hiddenVegRec.reasonKey, equals('reason_hidden_veggies'));
      },
    );
  });
}
