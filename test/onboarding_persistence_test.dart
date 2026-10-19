import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/app/app.dart';
import 'package:lunchbox_buddy/core/data/database/database.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Acceptance: add two kids, restart app: both persist and onboarding is skipped',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // 1. Shared in-memory Drift database across restart simulation
      final sharedDb = AppDatabase(NativeDatabase.memory());

      // Clean initial state: no kids
      final initialKids = await sharedDb
          .select(sharedDb.kidProfilesTable)
          .get();
      expect(initialKids.isEmpty, isTrue);

      // First session: start app with shared database
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(sharedDb)],
          child: const LunchboxBuddyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify redirected to onboarding because no kids exist
      expect(find.text('أهلاً بكِ في لانش بوكس بادي'), findsOneWidget);
      expect(find.text('ابدئي الآن'), findsOneWidget);

      // Tap "ابدئي الآن" to go to add child form
      await tester.tap(find.text('ابدئي الآن'));
      await tester.pumpAndSettle();

      expect(find.text('ضيفي أطفالك'), findsOneWidget);

      // Add first child: "سارة"
      final nameField = find.byType(TextFormField);
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, 'سارة');
      await tester.pumpAndSettle();

      // Select allergy: "بيض"
      await tester.tap(find.text('بيض'));
      await tester.pumpAndSettle();

      // Tap "حفظ ومتابعة"
      await tester.ensureVisible(find.text('حفظ ومتابعة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ ومتابعة'));
      await tester.pumpAndSettle();

      // Verify success screen for سارة
      expect(find.text('تم حفظ ملف سارة بنجاح!'), findsOneWidget);
      expect(find.text('إضافة طفل آخر'), findsOneWidget);

      // Tap "إضافة طفل آخر"
      await tester.tap(find.text('إضافة طفل آخر'));
      await tester.pumpAndSettle();

      // Add second child: "محمد"
      await tester.enterText(nameField, 'محمد');
      await tester.pumpAndSettle();

      // Select allergy: "حليب ومشتقاته"
      await tester.tap(find.text('حليب ومشتقاته'));
      await tester.pumpAndSettle();

      // Tap "حفظ ومتابعة"
      await tester.ensureVisible(find.text('حفظ ومتابعة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ ومتابعة'));
      await tester.pumpAndSettle();

      // Verify success screen for محمد
      expect(find.text('تم حفظ ملف محمد بنجاح!'), findsOneWidget);
      expect(find.text('إتمام والذهاب للرئيسية'), findsOneWidget);

      // Tap "إتمام والذهاب للرئيسية"
      await tester.tap(find.text('إتمام والذهاب للرئيسية'));
      await tester.pumpAndSettle();

      // Verify landed on Home screen and both kids are visible
      expect(find.text('وجبات اليوم المقترحة'), findsOneWidget);
      expect(find.text('سارة'), findsOneWidget);
      expect(find.text('محمد'), findsOneWidget);

      // Verify in database that 2 kids are saved
      final dbKids = await sharedDb.select(sharedDb.kidProfilesTable).get();
      expect(dbKids.length, equals(2));

      // =========================================================================
      // 2. SIMULATE APP KILL & REOPEN
      // =========================================================================
      // Build a fresh app instance pointing to the same persisted database
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(sharedDb)],
          child: const LunchboxBuddyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify onboarding is SKIPPED: app lands directly on Home!
      expect(find.text('وجبات اليوم المقترحة'), findsOneWidget);
      expect(find.text('أهلاً بكِ في لانش بوكس بادي'), findsNothing);

      // Verify both kids are still present and loaded from database!
      expect(find.text('سارة'), findsOneWidget);
      expect(find.text('محمد'), findsOneWidget);

      await sharedDb.close();
    },
  );
}
