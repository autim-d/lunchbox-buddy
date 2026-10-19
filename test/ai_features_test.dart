import 'package:drift/native.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_ranking_service.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_request_parser.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/recommendation_service.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';

import 'fixtures/ai_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late IngredientsDao ingredientsDao;
  late RecipesDao recipesDao;
  late FeedbackDao feedbackDao;
  late AppMetadataDao appMetadataDao;
  late SafetyFilter safetyFilter;
  late Scorer scorer;
  late RecommendationService recommendationService;

  const testConfig = AppConfig(
    geminiModel: 'gemini-2.5-flash',
    requestTimeoutSeconds: 8,
    maxRetries: 1,
  );

  final testIngredients = <Ingredient>[
    const Ingredient(
      id: 'chicken_breast',
      nameAr: 'صدر دجاج',
      nameEn: 'Chicken Breast',
      category: 'poultry',
      allergens: [],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'white_rice',
      nameAr: 'أرز أبيض',
      nameEn: 'White Rice',
      category: 'grains',
      allergens: [],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'cheddar_cheese',
      nameAr: 'جبن شيدر',
      nameEn: 'Cheddar Cheese',
      category: 'dairy',
      allergens: ['milk'],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'peanut_butter',
      nameAr: 'زبدة الفول السوداني',
      nameEn: 'Peanut Butter',
      category: 'spreads',
      allergens: ['peanuts'],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'spinach',
      nameAr: 'سبانخ',
      nameEn: 'Spinach',
      category: 'produce',
      allergens: [],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'egg',
      nameAr: 'بيض',
      nameEn: 'Egg',
      category: 'dairy',
      allergens: ['eggs'],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'banana',
      nameAr: 'موز',
      nameEn: 'Banana',
      category: 'produce',
      allergens: [],
      commonInRegion: true,
    ),
  ];

  final testRecipes = <Recipe>[
    const Recipe(
      id: 'rec_chicken_rice_bowl',
      title: 'وعاء دجاج وأرز دافئ',
      description: 'دجاج مطبوخ مع الأرز',
      prepMinutes: 10,
      cookMinutes: 10,
      servings: 2,
      tags: ['quick', 'protein', 'lunchbox'],
      ageMinMonths: 24,
      ingredients: [
        RecipeIngredient(ingredientId: 'chicken_breast', quantity: 150, unit: 'g'),
        RecipeIngredient(ingredientId: 'white_rice', quantity: 1, unit: 'cup'),
      ],
      steps: ['اطبخي الأرز والدجاج جيداً.'],
    ),
    const Recipe(
      id: 'rec_egg_toast_triangles',
      title: 'مثلثات التوست بالبيض',
      description: 'توست محمص مع بيض مخفوق',
      prepMinutes: 5,
      cookMinutes: 5,
      servings: 1,
      tags: ['quick', 'fun', 'lunchbox'],
      ageMinMonths: 18,
      ingredients: [
        RecipeIngredient(ingredientId: 'white_rice', quantity: 1, unit: 'piece'),
      ],
      steps: ['حمري التوست.'],
    ),
    const Recipe(
      id: 'rec_banana_oat_pancakes',
      title: 'بان كيك الموز والشوفان',
      description: 'بان كيك خفيف بدون سكر مكرر',
      prepMinutes: 5,
      cookMinutes: 10,
      servings: 2,
      tags: ['quick', 'sweet', 'lunchbox'],
      ageMinMonths: 12,
      ingredients: [
        RecipeIngredient(ingredientId: 'banana', quantity: 1, unit: 'piece'),
      ],
      steps: ['اخلطي واخبزي الفطائر.'],
    ),
    const Recipe(
      id: 'rec_cheese_wrap',
      title: 'لفافة الجبن المشوي',
      description: 'لفافة سهلة ومقرمشة',
      prepMinutes: 5,
      cookMinutes: 5,
      servings: 1,
      tags: ['quick', 'lunchbox'],
      ageMinMonths: 24,
      ingredients: [
        RecipeIngredient(ingredientId: 'cheddar_cheese', quantity: 50, unit: 'g'),
      ],
      steps: ['سخني اللفافة على المقلاة.'],
    ),
    const Recipe(
      id: 'rec_peanut_toast',
      title: 'توست زبدة الفول السوداني',
      description: 'توست بزبدة الفول السوداني الطبيعية',
      prepMinutes: 3,
      cookMinutes: 0,
      servings: 1,
      tags: ['quick', 'lunchbox'],
      ageMinMonths: 24,
      ingredients: [
        RecipeIngredient(ingredientId: 'peanut_butter', quantity: 30, unit: 'g'),
      ],
      steps: ['ادهني التوست وقدميه.'],
    ),
  ];

  final testKid = KidProfile(
    id: 'kid_salem',
    name: 'سالم',
    birthDate: DateTime(2021, 5, 1),
    allergies: const ['peanuts'], // Salem is allergic to peanuts!
    dislikes: const ['spinach'],
    pickyLevel: 1,
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    ingredientsDao = IngredientsDao(db);
    recipesDao = RecipesDao(db);
    feedbackDao = FeedbackDao(db);
    appMetadataDao = AppMetadataDao(db);
    safetyFilter = const SafetyFilter();
    scorer = const Scorer();

    recommendationService = RecommendationService(
      safetyFilter: safetyFilter,
      scorer: scorer,
      recipesDao: recipesDao,
      ingredientsDao: ingredientsDao,
      feedbackDao: feedbackDao,
    );

    // Seed test ingredients and recipes in memory db
    await ingredientsDao.insertIngredients(testIngredients);
    await recipesDao.insertRecipes(testRecipes);
  });

  tearDown(() async {
    await db.close();
  });

  group('Feature A: AiRequestParser', () {
    test('successfully parses Gulf Arabic query into structured AiParsedRequest', () async {
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return AiFixtures.validParseArabicRequestJson;
        },
      );

      final parser = AiRequestParser(
        aiClient: aiClient,
        ingredientsDao: ingredientsDao,
      );

      final result = await parser.parseRequest(
        rawText: 'ولدي ما يحب الخضار وعندي دجاج وأرز وما عندي وقت',
        customIngredients: testIngredients,
      );

      expect(result.isSuccess, isTrue);
      final parsed = result.valueOrNull!;
      expect(parsed.mealType, 'lunchbox');
      expect(parsed.maxMinutes, 20);
      expect(parsed.moodTags, contains('quick'));
      expect(parsed.availableIngredientIds, containsAll(['chicken_breast', 'white_rice']));
      expect(parsed.excludedIngredientIds, containsAll(['spinach', 'broccoli', 'carrot']));
      expect(parsed.unresolvedIngredients, isEmpty);
    });

    test('returns unknown food items in unresolvedIngredients list', () async {
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return AiFixtures.validParseWithUnresolvedJson;
        },
      );

      final parser = AiRequestParser(
        aiClient: aiClient,
        ingredientsDao: ingredientsDao,
      );

      final result = await parser.parseRequest(
        rawText: 'أبغى شي خفيف للمدرسة مع خبز تنور وبدون جبن',
        customIngredients: testIngredients,
      );

      expect(result.isSuccess, isTrue);
      final parsed = result.valueOrNull!;
      expect(parsed.excludedIngredientIds, contains('cheddar_cheese'));
      expect(parsed.unresolvedIngredients, contains('خبز تنور'));
    });

    test('empty raw text returns error immediately without invoking AI', () async {
      var invoked = false;
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          invoked = true;
          return AiFixtures.validParseArabicRequestJson;
        },
      );

      final parser = AiRequestParser(
        aiClient: aiClient,
        ingredientsDao: ingredientsDao,
      );

      final result = await parser.parseRequest(rawText: '   ');
      expect(result.isSuccess, isFalse);
      expect(invoked, isFalse);
    });

    test('malformed JSON response retries once and safely returns error failure', () async {
      var callCount = 0;
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          return AiFixtures.malformedParseRequestJson;
        },
      );

      final parser = AiRequestParser(
        aiClient: aiClient,
        ingredientsDao: ingredientsDao,
      );

      final result = await parser.parseRequest(
        rawText: 'سوي لي غداء سريع',
        customIngredients: testIngredients,
      );

      expect(result.isSuccess, isFalse);
      // Retried once: total 2 attempts
      expect(callCount, 2);
    });
  });

  group('Feature B: AiRankingService', () {
    test('takes candidates and returns top 3 with warm Arabic reasons & substitution tips', () async {
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return AiFixtures.validRankingJson;
        },
      );

      final rankingService = AiRankingService(
        aiClient: aiClient,
        recommendationService: recommendationService,
        safetyFilter: safetyFilter,
        appMetadataDao: appMetadataDao,
      );

      final request = MealSuggestionRequest(
        selectedKids: [testKid],
        mealType: 'lunchbox',
        maxMinutes: 30,
      );

      final recommendations = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );

      expect(recommendations.length, 3);
      expect(recommendations.first.isAiRanked, isTrue);
      expect(recommendations.first.recipe.id, 'rec_chicken_rice_bowl');
      expect(recommendations.first.aiReason, contains('بروتين'));
      expect(recommendations.first.substitutionTip, isNotNull);
    });

    test('rejects unknown candidate IDs and falls back silently to rule-based', () async {
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return AiFixtures.unknownIdsRankingJson;
        },
      );

      final rankingService = AiRankingService(
        aiClient: aiClient,
        recommendationService: recommendationService,
        safetyFilter: safetyFilter,
        appMetadataDao: appMetadataDao,
      );

      final request = MealSuggestionRequest(
        selectedKids: [testKid],
        mealType: 'lunchbox',
        maxMinutes: 30,
      );

      final recommendations = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );

      // Successfully fell back to rule-based engine results
      expect(recommendations.length, greaterThanOrEqualTo(1));
      // None of the unknown fake IDs are returned
      for (final rec in recommendations) {
        expect(rec.recipe.id, isNot('mystery_recipe_9999'));
        expect(rec.recipe.id, isNot('fake_nuggets_ultra'));
      }
    });

    test('re-runs SafetyFilter strictly: no result ever contains an allergen of selected kids', () async {
      // Suppose AI mistakenly included rec_peanut_toast for Salem who has a peanut allergy
      const allergyViolationRankingJson = '''
{
  "rankedItems": [
    {
      "recipeId": "rec_peanut_toast",
      "arabicReason": "سناك مليء بالطاقة.",
      "substitutionTip": null
    },
    {
      "recipeId": "rec_chicken_rice_bowl",
      "arabicReason": "وجبة مغذية جداً.",
      "substitutionTip": null
    },
    {
      "recipeId": "rec_banana_oat_pancakes",
      "arabicReason": "فطائر شهية.",
      "substitutionTip": null
    }
  ]
}
''';

      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return allergyViolationRankingJson;
        },
      );

      final rankingService = AiRankingService(
        aiClient: aiClient,
        recommendationService: recommendationService,
        safetyFilter: safetyFilter,
        appMetadataDao: appMetadataDao,
      );

      final request = MealSuggestionRequest(
        selectedKids: [testKid], // allergic to peanuts!
        mealType: 'lunchbox',
        maxMinutes: 30,
      );

      final recommendations = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );

      // Peanut toast must be completely stripped out
      final ids = recommendations.map((r) => r.recipe.id).toList();
      expect(ids, isNot(contains('rec_peanut_toast')));
    });

    test('caches ranking results in Drift app_metadata and serves from cache on second call', () async {
      var callCount = 0;
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          return AiFixtures.validRankingJson;
        },
      );

      final rankingService = AiRankingService(
        aiClient: aiClient,
        recommendationService: recommendationService,
        safetyFilter: safetyFilter,
        appMetadataDao: appMetadataDao,
      );

      final request = MealSuggestionRequest(
        selectedKids: [testKid],
        mealType: 'lunchbox',
        maxMinutes: 30,
      );

      // First invocation -> calls AI
      final firstResult = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );
      expect(callCount, 1);
      expect(firstResult.first.recipe.id, 'rec_chicken_rice_bowl');

      // Second invocation with identical request -> hits Drift cache, does NOT call AI
      final secondResult = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );
      expect(callCount, 1);
      expect(secondResult.first.recipe.id, 'rec_chicken_rice_bowl');
    });

    test('silent fallback to rule-based recommendations on network error or airplane mode', () async {
      final aiClient = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          throw Exception('SocketException: Failed host lookup (airplane mode)');
        },
      );

      final rankingService = AiRankingService(
        aiClient: aiClient,
        recommendationService: recommendationService,
        safetyFilter: safetyFilter,
        appMetadataDao: appMetadataDao,
      );

      final request = MealSuggestionRequest(
        selectedKids: [testKid],
        mealType: 'lunchbox',
        maxMinutes: 30,
      );

      final recommendations = await rankingService.rankAndAdapt(
        request: request,
        allRecipes: testRecipes,
        allIngredients: testIngredients,
        feedbacks: const <MealFeedback>[],
      );

      // Never throws; returns sensible rule-based cards
      expect(recommendations, isNotEmpty);
      expect(recommendations.first.isAiRanked, isFalse);
    });
  });
}
