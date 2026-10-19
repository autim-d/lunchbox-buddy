import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lunchbox_buddy/app/app.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';
import 'package:lunchbox_buddy/core/ui/dynamic_save_button.dart';
import 'package:lunchbox_buddy/core/ui/recipe_card.dart';
import 'package:lunchbox_buddy/core/ui/timer_pill.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_share_formatter.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/grocery_screen.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  final sampleIngredients = <Ingredient>[
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
      id: 'egg',
      nameAr: 'بيض',
      nameEn: 'Egg',
      category: 'dairy',
      allergens: ['eggs'],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'bread',
      nameAr: 'خبز',
      nameEn: 'Bread',
      category: 'bakery',
      allergens: ['gluten'],
      commonInRegion: true,
    ),
    const Ingredient(
      id: 'peanut_butter',
      nameAr: 'زبدة فول سوداني',
      nameEn: 'Peanut Butter',
      category: 'spreads',
      allergens: ['peanuts'],
      commonInRegion: true,
    ),
  ];

  final sampleRecipes = <Recipe>[
    const Recipe(
      id: 'rec_chicken_rice',
      title: 'أرز ودجاج دافئ',
      description: 'وجبة غداء مغذية للأطفال',
      prepMinutes: 10,
      cookMinutes: 10,
      servings: 1,
      tags: ['quick', 'lunchbox', 'dinner'],
      ageMinMonths: 18,
      ingredients: [
        RecipeIngredient(
          ingredientId: 'chicken_breast',
          quantity: 120,
          unit: 'g',
        ),
        RecipeIngredient(ingredientId: 'white_rice', quantity: 1, unit: 'cup'),
      ],
      steps: [
        'اطبخي الأرز والدجاج جيداً لمدة 10 دقائق.',
        'قدمي الوجبة دافئة في علبة الطعام.',
      ],
    ),
    const Recipe(
      id: 'rec_egg_toast',
      title: 'توست البيض الذهبي',
      description: 'فطور وسناك سريع ومحبوب',
      prepMinutes: 5,
      cookMinutes: 5,
      servings: 1,
      tags: ['quick', 'breakfast', 'lunchbox'],
      ageMinMonths: 12,
      ingredients: [
        RecipeIngredient(ingredientId: 'egg', quantity: 1, unit: 'piece'),
        RecipeIngredient(ingredientId: 'bread', quantity: 2, unit: 'slices'),
      ],
      steps: ['اخفقي البيضة وحمريها في المقلاة.', 'ضعيها بين شريحتي التوست.'],
    ),
    const Recipe(
      id: 'rec_rice_snack',
      title: 'كرات الأرز الصغيرة',
      description: 'كرات أرز ممتعة وسهلة الأكل',
      prepMinutes: 5,
      cookMinutes: 5,
      servings: 1,
      tags: ['quick', 'snack', 'fun', 'lunchbox'],
      ageMinMonths: 12,
      ingredients: [
        RecipeIngredient(ingredientId: 'white_rice', quantity: 1, unit: 'cup'),
      ],
      steps: ['شكلي الأرز المطبوخ إلى كرات صغيرة.'],
    ),
  ];

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final ingredientsDao = IngredientsDao(db);
    final recipesDao = RecipesDao(db);

    await ingredientsDao.insertIngredients(sampleIngredients);
    await recipesDao.insertRecipes(sampleRecipes);
  });

  tearDown(() async {
    await db.close();
  });

  group('End-to-End Integration Flow', () {
    testWidgets(
      'Flow 1: onboarding -> suggest -> recipe detail -> cook mode -> meal feedback',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appDatabaseProvider.overrideWithValue(db),
              allRecipesProvider.overrideWith((ref) => sampleRecipes),
              allIngredientsProvider.overrideWith((ref) => sampleIngredients),
              mealSuggestionsProvider.overrideWith((ref, request) async {
                return [
                  MealRecommendation(
                    recipe: sampleRecipes[0],
                    score: 20.0,
                    reasonKey: 'reason_kid_favorite',
                  ),
                  MealRecommendation(
                    recipe: sampleRecipes[1],
                    score: 15.0,
                    reasonKey: 'reason_quick',
                  ),
                  MealRecommendation(
                    recipe: sampleRecipes[2],
                    score: 10.0,
                    reasonKey: 'reason_balanced',
                  ),
                ];
              }),
            ],
            child: const LunchboxBuddyApp(),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Onboarding Screen: Welcome Step
        expect(find.text('لانش بوكس بادي'), findsWidgets);
        expect(find.text('ابدئي الآن'), findsOneWidget);

        // Tap "ابدئي الآن" -> navigates to Step 1: Add Child Form
        await tester.tap(find.text('ابدئي الآن'));
        await tester.pumpAndSettle();

        // 2. Add Child Form
        final nameField = find.byType(TextFormField);
        expect(nameField, findsOneWidget);
        await tester.enterText(nameField, 'فهد');
        await tester.pumpAndSettle();

        // Select Allergy chip (e.g. الفول السوداني)
        final peanutChip = find.text('الفول السوداني');
        if (peanutChip.evaluate().isNotEmpty) {
          await tester.tap(peanutChip);
          await tester.pumpAndSettle();
        }

        // Tap Submit child button ("حفظ ومتابعة")
        final saveChildButton = find.text('حفظ ومتابعة');
        expect(saveChildButton, findsOneWidget);
        await tester.tap(saveChildButton);
        await tester.pumpAndSettle();

        // 3. Onboarding Success Screen
        expect(find.text('تم حفظ ملف فهد بنجاح!'), findsOneWidget);
        final finishAndGoHomeButton = find.text('إتمام والذهاب للرئيسية');
        expect(finishAndGoHomeButton, findsOneWidget);
        await tester.tap(finishAndGoHomeButton);
        await tester.pumpAndSettle();

        // 4. Home Screen
        expect(find.text('فهد'), findsOneWidget);
        final suggestPrimaryButton = find.text('اقترحي لي وجبة');
        expect(suggestPrimaryButton, findsOneWidget);

        // Tap Primary Suggest CTA -> opens SuggestBottomSheet
        await tester.tap(suggestPrimaryButton);
        await tester.pumpAndSettle();

        // 5. Suggest Bottom Sheet
        final submitSuggestionButton = find.text('اقترحي الوجبات الآن');
        expect(submitSuggestionButton, findsOneWidget);
        await tester.tap(submitSuggestionButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // 6. Results Screen: 3 Swipeable Recipe Cards
        expect(find.byType(RecipeCard), findsOneWidget);

        // Tap on RecipeCard action button -> navigates to RecipeDetailScreen
        await tester.tap(find.text('طريقة التحضير').first);
        await tester.pumpAndSettle();

        // 7. Recipe Detail Screen
        expect(find.byType(DynamicSaveButton), findsOneWidget);
        expect(find.text('ابدأي الطهي'), findsOneWidget);

        // Tap Servings Stepper to scale quantities (Western digits)
        final incrementButton = find.byIcon(Icons.add_rounded);
        expect(incrementButton, findsWidgets);
        await tester.tap(incrementButton.first);
        await tester.pumpAndSettle();

        // Tap Dynamic Save Button (Save -> Saved ✓)
        await tester.tap(find.byType(DynamicSaveButton));
        await tester.pumpAndSettle();

        // Tap "ابدأي الطهي" -> navigates to CookModeScreen
        await tester.tap(find.text('ابدأي الطهي'));
        await tester.pumpAndSettle();

        // 8. Cook Mode Screen
        expect(find.byType(TimerPill), findsWidgets);
        expect(find.text('الخطوة التالية'), findsOneWidget);

        // Advance to step 2
        await tester.tap(find.text('الخطوة التالية'));
        await tester.pumpAndSettle();

        // Complete cooking on step 2
        final finishCookButton = find.text('إتمام الطهي');
        expect(finishCookButton, findsOneWidget);
        await tester.tap(finishCookButton);
        await tester.pumpAndSettle();

        // 9. Feedback & Celebration Screen
        expect(find.text('أحبها'), findsOneWidget);
        await tester.tap(find.text('أحبها'));
        await tester.pumpAndSettle();

        // Finish feedback
        final saveFeedbackButton = find.text('حفظ والعودة للرئيسية');
        expect(saveFeedbackButton, findsOneWidget);
        await tester.tap(saveFeedbackButton);
        await tester.pumpAndSettle();

        // Returned safely to home screen
        expect(find.text('فهد'), findsOneWidget);
      },
    );

    testWidgets(
      'Flow 2: Grocery list tick-off and WhatsApp plain text share formatting',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final groceryDao = GroceryDao(db);
        // Pre-populate grocery items with different aisles
        await groceryDao.insertItems([
          const GroceryItem(
            id: 'g_chicken',
            ingredientId: 'chicken_breast',
            nameAr: 'صدر دجاج',
            nameEn: 'Chicken Breast',
            aisle: 'protein',
            quantity: 250,
            unit: 'g',
          ),
          const GroceryItem(
            id: 'g_rice',
            ingredientId: 'white_rice',
            nameAr: 'أرز أبيض',
            nameEn: 'White Rice',
            aisle: 'grains',
            quantity: 2,
            unit: 'cup',
          ),
        ]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWithValue(db)],
            child: const MaterialApp(
              locale: Locale('ar'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Directionality(
                textDirection: TextDirection.rtl,
                child: GroceryListScreen(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify receipt items are rendered
        expect(find.text('صدر دجاج'), findsOneWidget);
        expect(find.text('أرز أبيض'), findsOneWidget);

        // Tap to tick off chicken
        await tester.tap(find.text('صدر دجاج'));
        await tester.pumpAndSettle();

        // Test WhatsApp share formatting
        final items = await groceryDao.getAllItems();
        final sharedText = GroceryShareFormatter.formatForWhatsApp(
          items,
          headerTitle: '🛒 قائمة التسوق - لانش بوكس بادي',
        );

        expect(sharedText, contains('لانش بوكس بادي'));
        expect(sharedText, contains('صدر دجاج'));
        expect(sharedText, contains('أرز أبيض'));
      },
    );
  });
}
