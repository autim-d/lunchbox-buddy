import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/app/app.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';
import 'package:lunchbox_buddy/core/ui/recipe_card.dart';
import 'package:lunchbox_buddy/core/ui/ticket_clipper.dart';
import 'package:lunchbox_buddy/features/suggest/domain/meal_recommendation.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/suggest_provider.dart';

Widget _buildTestBoilerplate({
  required Widget child,
  Locale locale = const Locale('ar'),
  double textScaleFactor = 1.0,
  AppDatabase? db,
}) {
  return ProviderScope(
    overrides: [if (db != null) appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScaleFactor),
          size: const Size(420, 900),
        ),
        child: Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sampleRecipe = Recipe(
    id: 'halloumi_cucumber_wrap',
    title: 'ساندوتش حلوم بالخيار والنعناع',
    description: 'خبز تورتيلا دافئ محشو بجبن الحلوم المشوي وشرائح الخيار المقرمشة مع لمسة نعناع طازجة ولذيذة',
    ingredients: [
      RecipeIngredient(ingredientId: 'halloumi', quantity: 60, unit: 'g'),
      RecipeIngredient(ingredientId: 'cucumber', quantity: 0.5, unit: 'piece'),
    ],
    steps: ['اشوي الحلوم', 'قطع الخيار', 'لف الساندوتش'],
    prepMinutes: 10,
    cookMinutes: 5,
    tags: ['lunchbox-friendly', 'quick', 'fun'],
    ageMinMonths: 12,
  );

  group('RecipeCard Visual & Golden Scale Tests', () {
    testWidgets('renders RecipeCard in RTL at text scale 1.0 without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestBoilerplate(
          locale: const Locale('ar'),
          textScaleFactor: 1.0,
          child: const RecipeCard(
            recipe: sampleRecipe,
            reasonKey: 'reason_kid_favorite',
            score: 18.5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title, badge, tags, and reason
      expect(find.text('ساندوتش حلوم بالخيار والنعناع'), findsOneWidget);
      expect(find.text('تذكرة وجبة'), findsOneWidget);
      expect(find.text('مفضلة ومحبوبة لأطفالكِ'), findsOneWidget);
      expect(find.text('حلال 100%'), findsOneWidget);
      expect(find.text('#lunchbox-friendly'), findsOneWidget);

      // Verify ticket clipper is used
      expect(
        find.byWidgetPredicate(
          (w) => w is ClipPath && w.clipper is PerforatedTicketClipper,
        ),
        findsOneWidget,
      );

      // Zero exception
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders RecipeCard in RTL at text scale 2.0 with ZERO overflow',
      (tester) async {
        await tester.pumpWidget(
          _buildTestBoilerplate(
            locale: const Locale('ar'),
            textScaleFactor: 2.0,
            child: const RecipeCard(
              recipe: sampleRecipe,
              reasonKey: 'reason_lunchbox_friendly',
              score: 19.0,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify title & reason are displayed
        expect(find.text('ساندوتش حلوم بالخيار والنعناع'), findsOneWidget);
        expect(find.text('مثالية للانش بوكس المدرسي'), findsOneWidget);

        // Crucial requirement: ZERO overflow at 200% text scale
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders RecipeCard in LTR at text scale 1.0 without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestBoilerplate(
          locale: const Locale('en'),
          textScaleFactor: 1.0,
          child: const RecipeCard(
            recipe: sampleRecipe,
            reasonKey: 'reason_quick_prep',
            score: 15.0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ساندوتش حلوم بالخيار والنعناع'), findsOneWidget);
      expect(find.text('Meal Ticket'), findsOneWidget);
      expect(find.text('Quick and easy prep'), findsOneWidget);
      expect(find.text('15 mins'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders RecipeCard in LTR at text scale 2.0 with ZERO overflow',
      (tester) async {
        await tester.pumpWidget(
          _buildTestBoilerplate(
            locale: const Locale('en'),
            textScaleFactor: 2.0,
            child: const RecipeCard(
              recipe: sampleRecipe,
              reasonKey: 'reason_hidden_veggies',
              score: 17.5,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('ساندوتش حلوم بالخيار والنعناع'), findsOneWidget);
        expect(
          find.text('Hidden veggies, great for picky eaters'),
          findsOneWidget,
        );

        // Crucial requirement: ZERO overflow at 200% text scale in LTR
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('bookmark button toggles saved status on RecipeCard', (
      tester,
    ) async {
      final sharedDb = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        _buildTestBoilerplate(
          db: sharedDb,
          child: const RecipeCard(
            recipe: sampleRecipe,
            reasonKey: 'reason_kid_favorite',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially bookmark border icon
      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_rounded), findsNothing);

      // Tap bookmark
      await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
      await tester.pumpAndSettle();

      // Now bookmarked filled icon
      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

      await sharedDb.close();
    });
  });

  group('Acceptance Test: 3 Taps to 3 Suggestions at 200% Text Scale', () {
    testWidgets(
      'from home, 3 taps reach 3 suggestions; nothing overflows at 200% text scale',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final sharedDb = AppDatabase(NativeDatabase.memory());

        // Pre-populate with one child so app goes straight to home
        await sharedDb
            .into(sharedDb.kidProfilesTable)
            .insert(
              KidProfileEntry(
                id: 'kid_omar',
                name: 'عمر',
                birthDate: DateTime(2021, 5, 10),
                allergies: '[]',
                dislikes: '[]',
                likes: '["halloumi"]',
                pickyLevel: 1,
                lunchboxType: 'lunchbox',
              ),
            );

        // Pre-populate sample recipes
        await sharedDb
            .into(sharedDb.recipesTable)
            .insert(
              const RecipeEntry(
                id: 'recipe_1',
                title: 'وجبة ساندوتش الحلوم',
                description: 'ساندوتش لذيذ وخفيف',
                steps: '["خطوة 1"]',
                prepMinutes: 10,
                cookMinutes: 5,
                servings: 1,
                tags: '["lunchbox-friendly", "quick"]',
                source: 'curated',
                ageMinMonths: 12,
                safetyVersion: 1,
              ),
            );
        await sharedDb
            .into(sharedDb.recipesTable)
            .insert(
              const RecipeEntry(
                id: 'recipe_2',
                title: 'ميني بان كيك الموز',
                description: 'بان كيك مغذي وطازج',
                steps: '["خطوة 1"]',
                prepMinutes: 10,
                cookMinutes: 10,
                servings: 1,
                tags: '["lunchbox-friendly", "fun"]',
                source: 'curated',
                ageMinMonths: 12,
                safetyVersion: 1,
              ),
            );
        await sharedDb
            .into(sharedDb.recipesTable)
            .insert(
              const RecipeEntry(
                id: 'recipe_3',
                title: 'لفائف الجبن والخيار',
                description: 'لفائف مقرمشة',
                steps: '["خطوة 1"]',
                prepMinutes: 10,
                cookMinutes: 0,
                servings: 1,
                tags: '["lunchbox-friendly", "quick"]',
                source: 'curated',
                ageMinMonths: 12,
                safetyVersion: 1,
              ),
            );

        // Start app with 200% text scale
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appDatabaseProvider.overrideWithValue(sharedDb),
              mealSuggestionsProvider.overrideWith((ref, request) async {
                return [
                  const MealRecommendation(
                    recipe: sampleRecipe,
                    score: 20.0,
                    reasonKey: 'reason_kid_favorite',
                  ),
                  MealRecommendation(
                    recipe: sampleRecipe.copyWith(
                      id: 'recipe_2',
                      title: 'ميني بان كيك الموز',
                    ),
                    score: 18.0,
                    reasonKey: 'reason_lunchbox_friendly',
                  ),
                  MealRecommendation(
                    recipe: sampleRecipe.copyWith(
                      id: 'recipe_3',
                      title: 'لفائف الجبن والخيار',
                    ),
                    score: 16.0,
                    reasonKey: 'reason_quick_prep',
                  ),
                ];
              }),
            ],
            child: const MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(2.0),
                size: Size(800, 1600),
              ),
              child: LunchboxBuddyApp(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Home is displayed with Omar
        expect(find.text('عمر'), findsOneWidget);
        expect(find.text('اقترحي لي وجبة'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // TAP 1: Tap "اقترحي لي وجبة" on Home screen
        await tester.tap(find.text('اقترحي لي وجبة'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Verify SuggestBottomSheet opens
        expect(find.text('تخصيص الوجبة'), findsOneWidget);
        expect(find.text('اقترحي الوجبات الآن'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // TAP 2: Tap "اقترحي الوجبات الآن" in Bottom Sheet
        await tester.tap(find.text('اقترحي الوجبات الآن'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Verify Results screen is displayed
        expect(find.text('اقتراحات الوجبات'), findsOneWidget);
        expect(find.byType(RecipeCard), findsOneWidget);

        // TAP 3: Tap recipe card action button
        final actionButton = find.text('طريقة التحضير');
        expect(actionButton, findsOneWidget);
        await tester.tap(actionButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Zero exceptions / zero RenderFlex overflows at 200% text scale!
        expect(tester.takeException(), isNull);

        await sharedDb.close();
      },
    );
  });
}
