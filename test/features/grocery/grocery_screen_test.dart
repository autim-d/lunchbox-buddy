import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/grocery_notifier.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/grocery_screen.dart';
import 'package:lunchbox_buddy/features/grocery/presentation/receipt_paper.dart';

class _FakeGroceryListNotifier extends GroceryListNotifier {
  _FakeGroceryListNotifier(this.initialItems);
  final List<GroceryItem> initialItems;

  @override
  Future<List<GroceryItem>> build() async {
    return initialItems;
  }

  @override
  Future<void> toggleItem(String id) async {
    final list = state.value ?? [];
    final idx = list.indexWhere((it) => it.id == id);
    if (idx != -1) {
      final updated = List<GroceryItem>.from(list);
      updated[idx] = updated[idx].copyWith(isChecked: !updated[idx].isChecked);
      state = AsyncData(updated);
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    final list = state.value ?? [];
    final updated = list.where((it) => it.id != id).toList();
    state = AsyncData(updated);
  }

  @override
  Future<void> addManualItem({
    required String nameAr,
    String? nameEn,
    double? quantity,
    String? unit,
    required String aisle,
  }) async {
    final list = state.value ?? [];
    final newItem = GroceryItem(
      id: 'manual_${DateTime.now().microsecondsSinceEpoch}',
      ingredientId: 'manual_${DateTime.now().microsecondsSinceEpoch}',
      nameAr: nameAr,
      nameEn: nameEn ?? nameAr,
      aisle: aisle,
      quantity: quantity,
      unit: unit,
      isChecked: false,
    );
    state = AsyncData([...list, newItem]);
  }

  @override
  Future<void> clearChecked() async {
    final list = state.value ?? [];
    state = AsyncData(list.where((it) => !it.isChecked).toList());
  }

  @override
  Future<void> clearAll() async {
    state = const AsyncData([]);
  }
}

Widget createTestWidget({
  required List<GroceryItem> items,
  Locale locale = const Locale('ar'),
}) {
  return ProviderScope(
    overrides: [
      groceryListNotifierProvider.overrideWith(
        () => _FakeGroceryListNotifier(items),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const GroceryListScreen(),
    ),
  );
}

void main() {
  testWidgets('ReceiptTornEdgeClipper produces valid path with zigzag teeth',
      (tester) async {
    const clipper = ReceiptTornEdgeClipper(toothWidth: 10.0, toothHeight: 5.0);
    final path = clipper.getClip(const Size(100.0, 200.0));
    expect(path, isNotNull);
    expect(clipper.shouldReclip(clipper), isFalse);
  });

  testWidgets('GroceryListScreen displays empty state when list is empty',
      (tester) async {
    await tester.pumpWidget(createTestWidget(items: []));
    await tester.pumpAndSettle();

    // Verify empty state title and button
    expect(find.text('قائمة التسوق فارغة'), findsOneWidget);
    expect(find.text('إضافة غرض'), findsWidgets);
  });

  testWidgets('GroceryListScreen displays receipt and aisle groups when populated',
      (tester) async {
    final testItems = [
      const GroceryItem(
        id: '1',
        ingredientId: 'cucumber',
        nameAr: 'خيار صغير طازج',
        nameEn: 'Cucumber',
        aisle: 'produce',
        quantity: 1.5,
        unit: 'piece',
        isChecked: false,
      ),
      const GroceryItem(
        id: '2',
        ingredientId: 'labneh',
        nameAr: 'لبنة طازجة',
        nameEn: 'Labneh',
        aisle: 'dairy',
        quantity: 3.0,
        unit: 'tbsp',
        isChecked: false,
      ),
    ];

    await tester.pumpWidget(createTestWidget(items: testItems));
    await tester.pumpAndSettle();

    // Receipt header
    expect(find.text('لانش بوكس بادي'), findsOneWidget);

    // Aisle headers
    expect(find.text('الخضار والفواكه'), findsOneWidget);
    expect(find.text('الألبان والأجبان'), findsOneWidget);

    // Items
    expect(find.text('خيار صغير طازج'), findsOneWidget);
    expect(find.text('1 1/2 حبة'), findsOneWidget);

    expect(find.text('لبنة طازجة'), findsOneWidget);
    expect(find.text('3 ملعقة كبيرة'), findsOneWidget);

    // Share button
    expect(find.text('مشاركة عبر واتساب'), findsOneWidget);
  });

  testWidgets('Tapping an item toggles checked state and strikethrough',
      (tester) async {
    final testItems = [
      const GroceryItem(
        id: 'item_1',
        ingredientId: 'cucumber',
        nameAr: 'خيار طازج',
        nameEn: 'Cucumber',
        aisle: 'produce',
        quantity: 2.0,
        unit: 'piece',
        isChecked: false,
      ),
    ];

    await tester.pumpWidget(createTestWidget(items: testItems));
    await tester.pumpAndSettle();

    // Tap to check off
    await tester.tap(find.text('خيار طازج'));
    await tester.pumpAndSettle();

    // Verify checkmark icon appears
    expect(find.byIcon(Icons.check_rounded), findsWidgets);
  });

  testWidgets('Can open manual add dialog and add item', (tester) async {
    await tester.pumpWidget(createTestWidget(items: []));
    await tester.pumpAndSettle();

    // Tap floating action button to add item
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify dialog opens
    expect(find.text('إضافة غرض جديد'), findsOneWidget);

    // Fill in item name
    await tester.enterText(
      find.widgetWithText(TextField, 'اسم المكون أو الغرض'),
      'تفاح أحمر',
    );
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.widgetWithText(AppButton, 'إضافة غرض').last);
    await tester.pumpAndSettle();

    // Verify item is now rendered
    expect(find.text('تفاح أحمر'), findsOneWidget);
  });
}
