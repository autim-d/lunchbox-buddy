import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';
import 'package:lunchbox_buddy/core/safety/safety_filter.dart';
import 'package:lunchbox_buddy/core/ui/recipe_card.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/cook_celebration_view.dart';
import 'package:lunchbox_buddy/features/feedback/presentation/history_screen.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_suggestion_request.dart';
import 'package:lunchbox_buddy/features/suggest/domain/recommendation_service.dart';
import 'package:lunchbox_buddy/features/suggest/domain/scorer.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

class _FakeSelectedKidsNotifier extends SelectedKidIdsNotifier {
  _FakeSelectedKidsNotifier(this.initial);
  final Set<String> initial;
  @override
  Set<String> build() => initial;
}

class _FakeKidsNotifier extends KidsListNotifier {
  _FakeKidsNotifier(this.kids);
  final List<KidProfile> kids;
  @override
  FutureOr<List<KidProfile>> build() => kids;

  @override
  Future<void> updateKid(KidProfile kid) async {
    state = AsyncData([kid]);
  }
}

Widget _buildTestWrapper({
  required Widget child,
  required AppDatabase db,
  Set<String>? selectedKidIds,
  List<KidProfile>? kids,
  List<Recipe>? recipes,
}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      allRecipesProvider.overrideWith((ref) => recipes ?? testRecipes),
      kidsListNotifierProvider.overrideWith(
        () => _FakeKidsNotifier(kids ?? [testKid]),
      ),
      if (selectedKidIds != null)
        selectedKidIdsProvider.overrideWith(
          () => _FakeSelectedKidsNotifier(selectedKidIds),
        ),
    ],
    child: MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

final testKid = KidProfile(
  id: 'kid_omar',
  name: 'عمر',
  birthDate: DateTime(2020, 5, 1),
  pickyLevel: 1,
  allergies: const [],
  dislikes: const [],
  likes: const ['cheese'],
);

final testIngredients = [
  const Ingredient(
    id: 'cheese',
    nameAr: 'جبن',
    nameEn: 'Cheese',
    category: 'dairy',
  ),
  const Ingredient(
    id: 'bread',
    nameAr: 'خبز',
    nameEn: 'Bread',
    category: 'bakery',
  ),
  const Ingredient(
    id: 'cucumber',
    nameAr: 'خيار',
    nameEn: 'Cucumber',
    category: 'produce',
  ),
  const Ingredient(
    id: 'tomato',
    nameAr: 'طماطم',
    nameEn: 'Tomato',
    category: 'produce',
  ),
  const Ingredient(id: 'egg', nameAr: 'بيض', nameEn: 'Egg', category: 'dairy'),
  const Ingredient(
    id: 'carrot',
    nameAr: 'جزر',
    nameEn: 'Carrot',
    category: 'produce',
  ),
];

final testRecipes = [
  const Recipe(
    id: 'rec_sandwich',
    title: 'ساندوتش جبن وخيار',
    description: 'ساندوتش خفيف',
    prepMinutes: 5,
    cookMinutes: 0,
    servings: 1,
    tags: ['quick', 'lunchbox-friendly'],
    ingredients: [
      RecipeIngredient(ingredientId: 'bread'),
      RecipeIngredient(ingredientId: 'cheese'),
      RecipeIngredient(ingredientId: 'cucumber'),
    ],
    steps: ['خطوة 1'],
  ),
  const Recipe(
    id: 'rec_toast',
    title: 'توست محمص بالجبن',
    description: 'توست ساخن',
    prepMinutes: 5,
    cookMinutes: 5,
    servings: 1,
    tags: ['quick', 'lunchbox-friendly'],
    ingredients: [
      RecipeIngredient(ingredientId: 'bread'),
      RecipeIngredient(ingredientId: 'cheese'),
    ],
    steps: ['خطوة 1'],
  ),
  const Recipe(
    id: 'rec_omelet',
    title: 'أومليت بالخضار',
    description: 'طبق بيض مغذي',
    prepMinutes: 5,
    cookMinutes: 5,
    servings: 1,
    tags: ['quick', 'lunchbox-friendly'],
    ingredients: [
      RecipeIngredient(ingredientId: 'egg'),
      RecipeIngredient(ingredientId: 'tomato'),
    ],
    steps: ['خطوة 1'],
  ),
  const Recipe(
    id: 'rec_salad',
    title: 'سلطة جزر وخيار',
    description: 'سلطة مقرمشة',
    prepMinutes: 10,
    cookMinutes: 0,
    servings: 1,
    tags: ['healthy', 'quick'],
    ingredients: [
      RecipeIngredient(ingredientId: 'carrot'),
      RecipeIngredient(ingredientId: 'cucumber'),
    ],
    steps: ['خطوة 1'],
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late RecipesDao recipesDao;
  late IngredientsDao ingredientsDao;
  late KidProfilesDao kidsDao;
  late FeedbackDao feedbackDao;
  late RecommendationService service;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    recipesDao = RecipesDao(db);
    ingredientsDao = IngredientsDao(db);
    kidsDao = KidProfilesDao(db);
    feedbackDao = FeedbackDao(db);

    await ingredientsDao.insertIngredients(testIngredients);
    await recipesDao.insertRecipes(testRecipes);
    await kidsDao.insertProfile(testKid);

    service = RecommendationService(
      safetyFilter: const SafetyFilter(),
      scorer: const Scorer(),
      recipesDao: recipesDao,
      ingredientsDao: ingredientsDao,
      feedbackDao: feedbackDao,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Feedback Loop Acceptance and Integration Tests', () {
    test('Acceptance: refuse a recipe for a kid, then request suggestions again: that recipe drops out of the top 3', () async {
      final request = MealSuggestionRequest(
        selectedKids: [testKid],
        mealType: 'lunchbox',
      );

      // 1. Initial request: rec_sandwich is in the top 3
      final initialTop3 = await service.getRecommendations(request);
      expect(initialTop3.length, equals(3));
      expect(initialTop3.map((r) => r.recipe.id), contains('rec_sandwich'));

      // 2. Kid refuses rec_sandwich: save MealFeedback into Drift
      await feedbackDao.insertFeedback(
        MealFeedback(
          id: 'fb_refuse_1',
          recipeId: 'rec_sandwich',
          kidId: testKid.id,
          reaction: 'refused',
          date: DateTime.now(),
        ),
      );

      // 3. Request suggestions again
      final updatedTop3 = await service.getRecommendations(request);

      // Acceptance criterion: that recipe drops completely out of the top 3!
      expect(
        updatedTop3.map((r) => r.recipe.id),
        isNot(contains('rec_sandwich')),
      );
    });

    test(
      'Loved recipes rank higher and other kids are not penalized',
      () async {
        final otherKid = KidProfile(
          id: 'kid_layla',
          name: 'ليلى',
          birthDate: DateTime(2021, 1, 1),
          pickyLevel: 0,
          allergies: const [],
          dislikes: const [],
          likes: const ['cheese'],
        );

        // Kid Omar refuses rec_sandwich
        await feedbackDao.insertFeedback(
          MealFeedback(
            id: 'fb_refuse_omar',
            recipeId: 'rec_sandwich',
            kidId: testKid.id,
            reaction: 'refused',
            date: DateTime.now(),
          ),
        );

        // For Layla, rec_sandwich is still recommended
        final laylaTop3 = await service.getRecommendations(
          MealSuggestionRequest(selectedKids: [otherKid], mealType: 'lunchbox'),
        );
        expect(laylaTop3.map((r) => r.recipe.id), contains('rec_sandwich'));

        // If Layla loves rec_toast, it receives a boost (+3.0)
        await feedbackDao.insertFeedback(
          MealFeedback(
            id: 'fb_love_layla',
            recipeId: 'rec_toast',
            kidId: otherKid.id,
            reaction: 'loved',
            date: DateTime.now().subtract(const Duration(days: 4)),
          ),
        );

        final laylaUpdated = await service.getRecommendations(
          MealSuggestionRequest(selectedKids: [otherKid], mealType: 'lunchbox'),
        );
        final toastRec = laylaUpdated.firstWhere(
          (r) => r.recipe.id == 'rec_toast',
        );
        expect(toastRec.breakdown['feedback']!, equals(3.0));
      },
    );

    testWidgets('RecipeCard displays animated stamp when recipe is loved', (
      tester,
    ) async {
      // rec_sandwich is marked loved in Drift
      await feedbackDao.insertFeedback(
        MealFeedback(
          id: 'fb_loved_1',
          recipeId: testRecipes[0].id,
          reaction: 'loved',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        _buildTestWrapper(
          db: db,
          child: RecipeCard(recipe: testRecipes[0]),
        ),
      );

      await tester.pumpAndSettle();

      // Verify KidsApprovedStamp is rendered on card
      expect(find.byType(KidsApprovedStamp), findsOneWidget);
      expect(find.text('معتمد من الصغار ✓'), findsOneWidget);
    });

    testWidgets(
      'CookCelebrationView renders 3 large buttons and saves feedback in Drift',
      (tester) async {
        await tester.pumpWidget(
          _buildTestWrapper(
            db: db,
            selectedKidIds: {testKid.id},
            child: CookCelebrationView(recipe: testRecipes[0]),
          ),
        );

        await tester.pumpAndSettle();

        // 3 large reaction buttons
        expect(find.text('أحبها'), findsOneWidget);
        expect(find.text('عادية'), findsOneWidget);
        expect(find.text('رفضها'), findsOneWidget);

        // Tap 'loved'
        await tester.tap(find.text('أحبها'));
        await tester.pumpAndSettle();

        // Reason chips appear
        expect(find.text('حار جداً 🌶️'), findsOneWidget);
        expect(find.text('مكون ما عجبه 🥦'), findsOneWidget);

        // Tap Save
        await tester.tap(find.text('حفظ والعودة للرئيسية'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));

        // Check feedback was saved in Drift
        final feedbacks = await feedbackDao.getAllFeedback();
        expect(feedbacks.length, equals(1));
        expect(feedbacks.first.recipeId, equals(testRecipes[0].id));
        expect(feedbacks.first.reaction, equals('loved'));
      },
    );

    testWidgets('HistoryScreen lists past meals with reactions', (
      tester,
    ) async {
      await feedbackDao.insertFeedback(
        MealFeedback(
          id: 'fb_hist_1',
          recipeId: testRecipes[0].id,
          kidId: testKid.id,
          reaction: 'loved',
          reasonTag: 'texture',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        _buildTestWrapper(db: db, child: const HistoryScreen()),
      );

      await tester.pumpAndSettle();

      expect(find.text('سجل الوجبات'), findsOneWidget);
      expect(find.text('ساندوتش جبن وخيار'), findsOneWidget);
      expect(find.text('عمر'), findsOneWidget);
      expect(find.text('أحبها'), findsOneWidget);
      expect(find.text('القوام 🥣'), findsOneWidget);
    });
  });
}
