import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/app/app.dart';

void main() {
  testWidgets('App starts in Arabic RTL and toggles to English LTR', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LunchboxBuddyApp()));
    await tester.pumpAndSettle();

    // 1. Verify app title in Arabic
    expect(find.text('لانش بوكس بادي'), findsWidgets);
    expect(find.text('اقترحي لي وجبة'), findsOneWidget);

    // 2. Verify directionality is RTL by default
    final BuildContext context = tester.element(find.text('اقترحي لي وجبة'));
    expect(Directionality.of(context), equals(TextDirection.rtl));

    // 3. Find and tap the language toggle chip (which offers "English")
    final englishChip = find.text('English');
    expect(englishChip, findsOneWidget);
    await tester.tap(englishChip);
    await tester.pumpAndSettle();

    // 4. Verify language switched to English
    expect(find.text('Lunchbox Buddy'), findsWidgets);
    expect(find.text('Suggest a meal'), findsOneWidget);

    // 5. Verify directionality flipped to LTR
    final BuildContext englishContext = tester.element(
      find.text('Suggest a meal'),
    );
    expect(Directionality.of(englishContext), equals(TextDirection.ltr));
  });
}
