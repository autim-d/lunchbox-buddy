import 'package:drift/drift.dart' show Value;
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
import 'package:lunchbox_buddy/core/utils/quantity_formatter.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/recipe_detail_screen.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_notifier.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_screen.dart';

Widget _buildTestApp({required Widget child, AppDatabase? db}) {
  return ProviderScope(
    overrides: [if (db != null) appDatabaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    ),
  );
}

const _testRecipe = Recipe(
  id: 'oat_pancake',
  title: 'بان كيك الشوفان والموز',
  description: 'بان كيك صحي وغني بالألياف والطاقة ومثالي للفطور.',
  prepMinutes: 10,
  cookMinutes: 10,
  servings: 1,
  tags: ['breakfast', 'quick', 'sweet'],
  steps: ['اهرسي الموز واخلطي المكونات.', 'اخبزي على مقلاة ساخنة حتى النضج.'],
  ingredients: [
    RecipeIngredient(
      ingredientId: 'oats',
      quantity: 0.25,
      unit: 'cup',
      displayText: 'شوفان مطحون',
      optional: false,
    ),
    RecipeIngredient(
      ingredientId: 'milk',
      quantity: 0.5,
      unit: 'cup',
      displayText: 'حليب قليل الدسم',
      optional: false,
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuantityFormatter Unit Tests', () {
    test('Formats vulgar fractions correctly', () {
      expect(QuantityFormatter.formatValue(0.25), equals('1/4'));
      expect(QuantityFormatter.formatValue(0.5), equals('1/2'));
      expect(QuantityFormatter.formatValue(0.75), equals('3/4'));
      expect(QuantityFormatter.formatValue(0.333), equals('1/3'));
      expect(QuantityFormatter.formatValue(0.667), equals('2/3'));
      expect(QuantityFormatter.formatValue(0.125), equals('1/8'));
      expect(QuantityFormatter.formatValue(1.5), equals('1 1/2'));
      expect(QuantityFormatter.formatValue(2.25), equals('2 1/4'));
      expect(QuantityFormatter.formatValue(3.0), equals('3'));
      expect(QuantityFormatter.formatValue(0.0), equals('0'));
    });

    test('Scales servings and quantities with Western digits', () {
      // 0.25 scaled from 1 to 2 servings -> 0.5 -> "1/2"
      expect(
        QuantityFormatter.format(0.25, baseServings: 1, targetServings: 2),
        equals('1/2'),
      );

      // 0.5 scaled from 2 to 1 serving -> 0.25 -> "1/4"
      expect(
        QuantityFormatter.format(0.5, baseServings: 2, targetServings: 1),
        equals('1/4'),
      );

      // 0.5 scaled from 1 to 3 servings -> 1.5 -> "1 1/2"
      expect(
        QuantityFormatter.format(0.5, baseServings: 1, targetServings: 3),
        equals('1 1/2'),
      );

      // 0.25 scaled from 1 to 4 servings -> 1.0 -> "1"
      expect(
        QuantityFormatter.format(0.25, baseServings: 1, targetServings: 4),
        equals('1'),
      );

      // null base quantity returns empty string
      expect(QuantityFormatter.format(null), equals(''));
    });
  });

  group('RecipeDetailScreen Widget Tests', () {
    testWidgets(
      'Displays header illustration, Western digit servings, and scales quantities on stepper tap',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);

        await tester.pumpWidget(
          _buildTestApp(
            db: db,
            child: RecipeDetailScreen(
              recipeId: _testRecipe.id,
              initialRecipe: _testRecipe,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Verify Title & Description
        expect(find.text('بان كيك الشوفان والموز'), findsOneWidget);
        expect(
          find.text('التحضير: 10 د • الطهي: 10 د'),
          findsNothing,
        ); // using time badges
        expect(find.text('10 د'), findsNWidgets(2)); // prep & cook

        // 2. Initial servings = 1 (Western digit)
        expect(find.text('1'), findsWidgets); // servings stepper shows 1
        expect(find.text('1/4 كوب'), findsOneWidget);
        expect(find.text('1/2 كوب'), findsOneWidget);

        // 3. Tap increment servings stepper (+)
        final plusButton = find.byTooltip('زيادة الحصص');
        expect(plusButton, findsOneWidget);
        await tester.tap(plusButton);
        await tester.pumpAndSettle();

        // Servings is now 2
        expect(find.text('2'), findsWidgets);
        // Quantities scaled: 0.25 -> 0.5 (1/2), 0.5 -> 1.0 (1)
        expect(find.text('1/2 كوب'), findsOneWidget); // oats is now 1/2
        expect(find.text('1 كوب'), findsOneWidget); // milk is now 1

        // 4. Tap increment again (+) to 3 servings
        await tester.tap(plusButton);
        await tester.pumpAndSettle();

        expect(find.text('3'), findsWidgets);
        // Quantities scaled: 0.5 * 3 = 1.5 -> "1 1/2"
        expect(find.text('1 1/2 كوب'), findsOneWidget);

        // 5. Tap decrement stepper (-) down to 1
        final minusButton = find.byTooltip('تقليل الحصص');
        await tester.tap(minusButton);
        await tester.pumpAndSettle();
        await tester.tap(minusButton);
        await tester.pumpAndSettle();

        expect(find.text('1/4 كوب'), findsOneWidget);
      },
    );

    testWidgets('Toggles "I have it" checkbox and updates on-hand counter', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        _buildTestApp(
          db: db,
          child: RecipeDetailScreen(
            recipeId: _testRecipe.id,
            initialRecipe: _testRecipe,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial on-hand counter: 0 of 2
      expect(find.text('المتوفر لديكِ: 0 من 2'), findsOneWidget);

      // Tap first ingredient to check it
      final firstCheckbox = find.byType(Checkbox).first;
      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();

      // Counter updates to 1 of 2
      expect(find.text('المتوفر لديكِ: 1 من 2'), findsOneWidget);

      // Tap second ingredient to check it
      final secondCheckbox = find.byType(Checkbox).last;
      await tester.tap(secondCheckbox);
      await tester.pumpAndSettle();

      // Counter updates to 2 of 2
      expect(find.text('المتوفر لديكِ: 2 من 2'), findsOneWidget);

      // Tap again to uncheck
      await tester.tap(secondCheckbox);
      await tester.pumpAndSettle();
      expect(find.text('المتوفر لديكِ: 1 من 2'), findsOneWidget);
    });

    testWidgets('DynamicSaveButton toggles save state with smooth feedback', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        _buildTestApp(
          db: db,
          child: RecipeDetailScreen(
            recipeId: _testRecipe.id,
            initialRecipe: _testRecipe,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially unsaved
      expect(find.text('حفظ الوصفة'), findsWidgets);

      // Tap save button
      await tester.tap(find.text('حفظ الوصفة').first);
      // Pump short duration for saving animation
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Saved state
      expect(find.text('تم الحفظ ✓'), findsWidgets);
    });

    testWidgets('Add missing items to grocery list displays snackbar stub', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        _buildTestApp(
          db: db,
          child: RecipeDetailScreen(
            recipeId: _testRecipe.id,
            initialRecipe: _testRecipe,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final missingButton = find.text('إضافة النواقص لقائمة التسوق');
      expect(missingButton, findsOneWidget);
      await tester.tap(missingButton);
      await tester.pump();

      expect(
        find.text('تمت إضافة المكونات الناقصة إلى قائمة التسوق بنجاح!'),
        findsOneWidget,
      );
    });
  });

  group('Saved Recipes Offline Persistence Tests', () {
    test('Acceptance: saved recipes survive app restart', () async {
      // Shared SQLite database in memory across simulated sessions
      final sharedDb = AppDatabase(NativeDatabase.memory());
      addTearDown(sharedDb.close);

      // Seed test recipe into shared DB
      await sharedDb
          .into(sharedDb.recipesTable)
          .insert(
            RecipesTableCompanion.insert(
              id: _testRecipe.id,
              title: _testRecipe.title,
              description: _testRecipe.description,
              prepMinutes: _testRecipe.prepMinutes,
              cookMinutes: _testRecipe.cookMinutes,
              servings: Value(_testRecipe.servings),
              tags: '["breakfast", "quick"]',
              steps: '["Step 1", "Step 2"]',
            ),
          );

      // --- Session 1: Save recipe ---
      final container1 = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(sharedDb)],
      );
      addTearDown(container1.dispose);

      // Wait for initial load
      final initialSaved = await container1.read(savedRecipeIdsProvider.future);
      expect(initialSaved.isEmpty, isTrue);

      // Save recipe
      await container1
          .read(savedRecipeIdsProvider.notifier)
          .toggleSave(_testRecipe.id);

      final savedAfter1 = await container1.read(savedRecipeIdsProvider.future);
      expect(savedAfter1.contains(_testRecipe.id), isTrue);

      final savedList1 = await container1.read(savedRecipesListProvider.future);
      expect(savedList1.length, equals(1));
      expect(savedList1.first.id, equals(_testRecipe.id));

      // --- Session 2: App Restart (New ProviderContainer over same DB) ---
      final container2 = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(sharedDb)],
      );
      addTearDown(container2.dispose);

      final restoredSavedIds = await container2.read(
        savedRecipeIdsProvider.future,
      );
      expect(restoredSavedIds.contains(_testRecipe.id), isTrue);

      final restoredRecipesList = await container2.read(
        savedRecipesListProvider.future,
      );
      expect(restoredRecipesList.length, equals(1));
      expect(restoredRecipesList.first.id, equals(_testRecipe.id));
      expect(restoredRecipesList.first.title, equals(_testRecipe.title));

      // Remove and undo testing
      await container2
          .read(savedRecipeIdsProvider.notifier)
          .removeRecipe(_testRecipe.id);
      final emptyList = await container2.read(savedRecipesListProvider.future);
      expect(emptyList.isEmpty, isTrue);

      await container2
          .read(savedRecipeIdsProvider.notifier)
          .saveRecipe(_testRecipe.id);
      final restoredList = await container2.read(
        savedRecipesListProvider.future,
      );
      expect(restoredList.length, equals(1));
    });

    testWidgets(
      'SavedRecipesScreen displays saved recipes and removes with undo',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);

        await db
            .into(db.recipesTable)
            .insert(
              RecipesTableCompanion.insert(
                id: _testRecipe.id,
                title: _testRecipe.title,
                description: _testRecipe.description,
                prepMinutes: _testRecipe.prepMinutes,
                cookMinutes: _testRecipe.cookMinutes,
                servings: Value(_testRecipe.servings),
                tags: '["breakfast"]',
                steps: '["Step 1"]',
              ),
            );

        // Pre-save recipe in metadata
        final metadataDao = AppMetadataDao(db);
        await metadataDao.setValue('saved_recipe_ids', '["${_testRecipe.id}"]');

        await tester.pumpWidget(
          _buildTestApp(db: db, child: const SavedRecipesScreen()),
        );
        await tester.pumpAndSettle();

        // Verify saved recipe appears
        expect(find.text('بان كيك الشوفان والموز'), findsOneWidget);
        expect(find.text('الوصفات المحفوظة'), findsOneWidget);

        // Tap remove button
        final removeButton = find.byTooltip('حذف');
        expect(removeButton, findsOneWidget);
        await tester.tap(removeButton);
        await tester.pumpAndSettle();

        // Snackbar appears with undo button
        expect(find.text('تمت إزالة الوصفة من المفضلة'), findsOneWidget);
        expect(find.text('تراجع'), findsOneWidget);

        // Screen is now empty
        expect(find.text('لا توجد وصفات محفوظة بعد'), findsOneWidget);

        // Tap undo
        await tester.tap(find.text('تراجع'));
        await tester.pumpAndSettle();

        // Recipe restored
        expect(find.text('بان كيك الشوفان والموز'), findsOneWidget);
      },
    );
  });
}
