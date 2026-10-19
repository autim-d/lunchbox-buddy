library;

/// Formatter for converting grocery lists into plain text formatted for WhatsApp.
/// RTL-safe, grouped by aisle category, one item per line.
/// Pure Dart, no Flutter imports.

import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/utils/quantity_formatter.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_merger.dart';

/// Information and formatting metadata for grocery aisle categories
class AisleMetadata {
  const AisleMetadata({
    required this.key,
    required this.nameAr,
    required this.nameEn,
    required this.iconEmoji,
    required this.sortOrder,
  });

  final String key;
  final String nameAr;
  final String nameEn;
  final String iconEmoji;
  final int sortOrder;
}

/// Formatter that generates a WhatsApp-friendly plain text grocery list
class GroceryShareFormatter {
  GroceryShareFormatter._();

  static const List<AisleMetadata> aisles = [
    AisleMetadata(
      key: 'produce',
      nameAr: 'الخضار والفواكه',
      nameEn: 'Produce & Fruits',
      iconEmoji: '🥬',
      sortOrder: 1,
    ),
    AisleMetadata(
      key: 'dairy',
      nameAr: 'الألبان والأجبان',
      nameEn: 'Dairy & Cheese',
      iconEmoji: '🧀',
      sortOrder: 2,
    ),
    AisleMetadata(
      key: 'bakery',
      nameAr: 'المخبوزات',
      nameEn: 'Bakery & Bread',
      iconEmoji: '🍞',
      sortOrder: 3,
    ),
    AisleMetadata(
      key: 'protein',
      nameAr: 'اللحوم والبروتينات',
      nameEn: 'Meat & Protein',
      iconEmoji: '🥩',
      sortOrder: 4,
    ),
    AisleMetadata(
      key: 'pantry',
      nameAr: 'المؤونة والمعلبات',
      nameEn: 'Pantry & Staples',
      iconEmoji: '🥫',
      sortOrder: 5,
    ),
    AisleMetadata(
      key: 'spices',
      nameAr: 'البهارات والتوابل',
      nameEn: 'Spices & Seasoning',
      iconEmoji: '🧂',
      sortOrder: 6,
    ),
    AisleMetadata(
      key: 'other',
      nameAr: 'أغراض أخرى',
      nameEn: 'Other Items',
      iconEmoji: '🛍️',
      sortOrder: 7,
    ),
  ];

  static AisleMetadata getAisleMetadata(String aisleKey) {
    final key = aisleKey.trim().toLowerCase();
    return aisles.firstWhere(
      (a) => a.key == key,
      orElse: () {
        if (key == 'meat') {
          return aisles.firstWhere((a) => a.key == 'protein');
        }
        return aisles.last; // 'other'
      },
    );
  }

  /// Formats the grocery items list into a clean, RTL-safe WhatsApp text message
  static String formatForWhatsApp(
    List<GroceryItem> items, {
    bool includeChecked = true,
    String? headerTitle,
  }) {
    if (items.isEmpty) {
      return headerTitle ?? '🛒 قائمة التسوق فارغة';
    }

    final buffer = StringBuffer();
    final title = headerTitle ?? '🛒 قائمة التسوق - لانش بوكس بادي';
    buffer.writeln(title);
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');

    // Separate pending vs checked items
    final pendingItems = items.where((it) => !it.isChecked).toList();
    final checkedItems = items.where((it) => it.isChecked).toList();

    // Group pending items by aisle
    final Map<String, List<GroceryItem>> grouped = {};
    for (final item in pendingItems) {
      final aisleKey = _normalizeAisle(item.aisle);
      grouped.putIfAbsent(aisleKey, () => []).add(item);
    }

    // Sort aisles according to predetermined order
    final sortedAisleKeys = grouped.keys.toList()
      ..sort((a, b) {
        final orderA = getAisleMetadata(a).sortOrder;
        final orderB = getAisleMetadata(b).sortOrder;
        return orderA.compareTo(orderB);
      });

    for (final aisleKey in sortedAisleKeys) {
      final meta = getAisleMetadata(aisleKey);
      final aisleItems = grouped[aisleKey]!;

      buffer.writeln();
      buffer.writeln('${meta.iconEmoji} ${meta.nameAr}:');

      for (final item in aisleItems) {
        buffer.writeln('• ${_formatItemLine(item)}');
      }
    }

    // Append checked items if requested and any exist
    if (includeChecked && checkedItems.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('✅ تم شراؤها:');
      for (final item in checkedItems) {
        buffer.writeln('• ${_formatItemLine(item)}');
      }
    }

    return buffer.toString().trim();
  }

  static String _formatItemLine(GroceryItem item) {
    if (item.quantity == null || item.quantity == 0) {
      return item.nameAr;
    }

    final qtyStr = QuantityFormatter.format(item.quantity);
    final unitStr = UnitConverter.formatUnitAr(item.unit);

    if (unitStr.isNotEmpty) {
      return '${item.nameAr} ($qtyStr $unitStr)';
    } else {
      return '${item.nameAr} ($qtyStr)';
    }
  }

  static String _normalizeAisle(String aisle) {
    final lower = aisle.trim().toLowerCase();
    if (lower == 'meat') return 'protein';
    return lower;
  }
}
