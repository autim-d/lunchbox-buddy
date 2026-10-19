import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/core/ui/chip_selector.dart';
import 'package:lunchbox_buddy/core/ui/hold_button.dart';
import 'package:lunchbox_buddy/core/ui/kid_avatar_picker.dart';

void main() {
  group('AppButton Widget Tests in RTL', () {
    testWidgets('renders Arabic label with >= 48dp touch target in RTL', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: AppButton(
                  label: 'اقترحي لي وجبة',
                  icon: Icons.lunch_dining_rounded,
                  onPressed: () => tapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify label and icon exist
      expect(find.text('اقترحي لي وجبة'), findsOneWidget);
      expect(find.byIcon(Icons.lunch_dining_rounded), findsOneWidget);

      // Verify minimum touch target height >= 48dp
      final buttonSize = tester.getSize(find.byType(AppButton));
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));

      // Tap and verify callback
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets(
      'tactile press feel: moves face down 2-3px on press and resets on release',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Center(
                  child: AppButton(label: 'حفظ ومتابعة', onPressed: () {}),
                ),
              ),
            ),
          ),
        );

        final animatedContainerFinder = find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(AnimatedContainer),
        );

        // Initial resting state: translation is 0
        AnimatedContainer container = tester.widget<AnimatedContainer>(
          animatedContainerFinder,
        );
        expect(container.transform, equals(Matrix4.translationValues(0, 0, 0)));

        // Press down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(AppButton)),
        );
        await tester.pumpAndSettle();

        // Depressed state: face translated down 3px
        container = tester.widget<AnimatedContainer>(animatedContainerFinder);
        expect(
          container.transform,
          equals(Matrix4.translationValues(0, 3.0, 0)),
        );

        // Release
        await gesture.up();
        await tester.pumpAndSettle();

        // Restored state: face returns to 0
        container = tester.widget<AnimatedContainer>(animatedContainerFinder);
        expect(container.transform, equals(Matrix4.translationValues(0, 0, 0)));
      },
    );

    testWidgets('shows loading indicator and prevents tap when loading', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: AppButton(
                  label: 'حفظ ومتابعة',
                  isLoading: true,
                  onPressed: () => tapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(tapped, isFalse);
    });
  });

  group('ChipSelector Widget Tests in RTL', () {
    testWidgets(
      'renders items and handles multi-selection in RTL with >= 48dp targets',
      (tester) async {
        final items = [
          const ChipItem(id: 'milk', label: 'حليب', icon: Icons.local_drink),
          const ChipItem(id: 'egg', label: 'بيض', icon: Icons.egg),
          const ChipItem(id: 'wheat', label: 'قمح', icon: Icons.grain),
        ];

        Set<String> selected = {'milk'};

        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return ChipSelector(
                      items: items,
                      selectedIds: selected,
                      onChanged: (updated) {
                        setState(() => selected = updated);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Verify RTL directionality is applied
        final textDirection = Directionality.of(
          tester.element(find.byType(ChipSelector)),
        );
        expect(textDirection, equals(TextDirection.rtl));

        // Verify touch target constraints >= 48dp
        final constrainedBoxes = tester.widgetList<ConstrainedBox>(
          find.descendant(
            of: find.byType(ChipSelector),
            matching: find.byType(ConstrainedBox),
          ),
        );
        for (final box in constrainedBoxes) {
          expect(box.constraints.minHeight, greaterThanOrEqualTo(48.0));
        }

        // Verify initial state
        expect(find.text('حليب'), findsOneWidget);
        expect(find.text('بيض'), findsOneWidget);
        expect(find.text('قمح'), findsOneWidget);

        // 'milk' is selected, so it shows a checkmark icon
        expect(find.byIcon(Icons.check_rounded), findsOneWidget);

        // Tap 'بيض' to toggle selection
        await tester.tap(find.text('بيض'));
        await tester.pumpAndSettle();

        expect(selected.contains('egg'), isTrue);
        expect(selected.contains('milk'), isTrue);
        expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

        // Tap 'milk' to deselect it
        await tester.tap(find.text('حليب'));
        await tester.pumpAndSettle();

        expect(selected.contains('milk'), isFalse);
        expect(selected.contains('egg'), isTrue);
      },
    );

    testWidgets('handles single-select mode properly', (tester) async {
      final items = [
        const ChipItem(id: 'cold', label: 'بارد'),
        const ChipItem(id: 'hot', label: 'ساخن'),
      ];

      Set<String> selected = {'cold'};

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return ChipSelector(
                    isMultiSelect: false,
                    items: items,
                    selectedIds: selected,
                    onChanged: (updated) {
                      setState(() => selected = updated);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap 'hot'
      await tester.tap(find.text('ساخن'));
      await tester.pumpAndSettle();

      expect(selected, equals({'hot'}));
    });
  });

  group('KidAvatarPicker Tests', () {
    testWidgets('renders curated vector avatars and updates selection', (
      tester,
    ) async {
      String selectedId = 'avatar_chef';

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return KidAvatarPicker(
                    selectedAvatarId: selectedId,
                    onSelected: (id) => setState(() => selectedId = id),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(KidAvatarPicker), findsOneWidget);
      expect(selectedId, equals('avatar_chef'));

      // Tap on 'avatar_star'
      await tester.tap(find.bySemanticsLabel('avatar_star'));
      await tester.pumpAndSettle();

      expect(selectedId, equals('avatar_star'));
    });
  });

  group('HoldButton Widget Tests in RTL', () {
    testWidgets('displays idle label and does not trigger on quick release', (
      tester,
    ) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: HoldButton(
                  idleLabel: 'اضغطي مطولاً للحذف',
                  holdingLabel: 'جاري الحذف...',
                  duration: const Duration(milliseconds: 600),
                  onConfirmed: () => confirmed = true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('اضغطي مطولاً للحذف'), findsOneWidget);

      // Short tap without holding
      await tester.tap(find.byType(HoldButton));
      await tester.pumpAndSettle();

      expect(confirmed, isFalse);
    });

    testWidgets('triggers onConfirmed when held until completion', (
      tester,
    ) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: HoldButton(
                  idleLabel: 'اضغطي مطولاً للحذف',
                  holdingLabel: 'جاري الحذف...',
                  duration: const Duration(milliseconds: 500),
                  onConfirmed: () => confirmed = true,
                ),
              ),
            ),
          ),
        ),
      );

      // Press and hold for full duration
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(HoldButton)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('جاري الحذف...'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });
  });
}
