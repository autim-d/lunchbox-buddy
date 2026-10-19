library;

/// Unit conversion and duplicate merging logic for the grocery list.
/// Pure Dart, no Flutter imports.

import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';

/// Dimension category for measurement units
enum UnitDimension {
  mass,
  metricVolume,
  culinaryVolume,
  count,
  other,
}

/// Unit details containing dimension and conversion factor to dimension's base unit
class UnitDefinition {
  const UnitDefinition({
    required this.dimension,
    required this.factorToBase,
    required this.canonicalUnit,
    required this.arabicName,
  });

  final UnitDimension dimension;
  final double factorToBase;
  final String canonicalUnit;
  final String arabicName;
}

/// Registry and conversion logic for measurement units
class UnitConverter {
  UnitConverter._();

  // Mass base: gram (g)
  // Metric volume base: milliliter (ml)
  // Culinary volume base: teaspoon (tsp)  [1 tbsp = 3 tsp, 1 cup = 48 tsp]
  // Count base: piece

  static const Map<String, UnitDefinition> _definitions = {
    // Mass
    'g': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1.0,
      canonicalUnit: 'g',
      arabicName: 'جرام',
    ),
    'gram': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1.0,
      canonicalUnit: 'g',
      arabicName: 'جرام',
    ),
    'grams': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1.0,
      canonicalUnit: 'g',
      arabicName: 'جرام',
    ),
    'جرام': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1.0,
      canonicalUnit: 'g',
      arabicName: 'جرام',
    ),
    'غرام': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1.0,
      canonicalUnit: 'g',
      arabicName: 'جرام',
    ),
    'kg': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),
    'kilogram': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),
    'kilograms': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),
    'كجم': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),
    'كيلو': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),
    'كيلوغرام': UnitDefinition(
      dimension: UnitDimension.mass,
      factorToBase: 1000.0,
      canonicalUnit: 'kg',
      arabicName: 'كجم',
    ),

    // Metric Volume
    'ml': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1.0,
      canonicalUnit: 'ml',
      arabicName: 'مل',
    ),
    'milliliter': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1.0,
      canonicalUnit: 'ml',
      arabicName: 'مل',
    ),
    'milliliters': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1.0,
      canonicalUnit: 'ml',
      arabicName: 'مل',
    ),
    'مل': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1.0,
      canonicalUnit: 'ml',
      arabicName: 'مل',
    ),
    'l': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),
    'liter': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),
    'liters': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),
    'litre': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),
    'litres': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),
    'لتر': UnitDefinition(
      dimension: UnitDimension.metricVolume,
      factorToBase: 1000.0,
      canonicalUnit: 'l',
      arabicName: 'لتر',
    ),

    // Culinary Volume (spoons & cups)
    'tsp': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 1.0,
      canonicalUnit: 'tsp',
      arabicName: 'ملعقة صغيرة',
    ),
    'teaspoon': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 1.0,
      canonicalUnit: 'tsp',
      arabicName: 'ملعقة صغيرة',
    ),
    'teaspoons': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 1.0,
      canonicalUnit: 'tsp',
      arabicName: 'ملعقة صغيرة',
    ),
    'ملعقة صغيرة': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 1.0,
      canonicalUnit: 'tsp',
      arabicName: 'ملعقة صغيرة',
    ),
    'tbsp': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 3.0,
      canonicalUnit: 'tbsp',
      arabicName: 'ملعقة كبيرة',
    ),
    'tablespoon': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 3.0,
      canonicalUnit: 'tbsp',
      arabicName: 'ملعقة كبيرة',
    ),
    'tablespoons': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 3.0,
      canonicalUnit: 'tbsp',
      arabicName: 'ملعقة كبيرة',
    ),
    'ملعقة كبيرة': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 3.0,
      canonicalUnit: 'tbsp',
      arabicName: 'ملعقة كبيرة',
    ),
    'cup': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 48.0,
      canonicalUnit: 'cup',
      arabicName: 'كوب',
    ),
    'cups': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 48.0,
      canonicalUnit: 'cup',
      arabicName: 'كوب',
    ),
    'كوب': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 48.0,
      canonicalUnit: 'cup',
      arabicName: 'كوب',
    ),
    'أكواب': UnitDefinition(
      dimension: UnitDimension.culinaryVolume,
      factorToBase: 48.0,
      canonicalUnit: 'cup',
      arabicName: 'أكواب',
    ),

    // Counts
    'piece': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبة',
    ),
    'pieces': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبة',
    ),
    'حبة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبة',
    ),
    'حبات': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبات',
    ),
    'قطعة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبة',
    ),
    'قطع': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'piece',
      arabicName: 'حبات',
    ),
    'slice': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'slices',
      arabicName: 'شريحة',
    ),
    'slices': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'slices',
      arabicName: 'شرائح',
    ),
    'شريحة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'slices',
      arabicName: 'شريحة',
    ),
    'شرائح': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'slices',
      arabicName: 'شرائح',
    ),
    'leaf': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'leaves',
      arabicName: 'ورقة',
    ),
    'leaves': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'leaves',
      arabicName: 'أوراق',
    ),
    'ورقة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'leaves',
      arabicName: 'ورقة',
    ),
    'أوراق': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'leaves',
      arabicName: 'أوراق',
    ),
    'can': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'can',
      arabicName: 'علبة',
    ),
    'cans': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'can',
      arabicName: 'علب',
    ),
    'علبة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'can',
      arabicName: 'علبة',
    ),
    'علب': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'can',
      arabicName: 'علب',
    ),
    'pinch': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'pinch',
      arabicName: 'رشة',
    ),
    'رشة': UnitDefinition(
      dimension: UnitDimension.count,
      factorToBase: 1.0,
      canonicalUnit: 'pinch',
      arabicName: 'رشة',
    ),
  };

  /// Resolves the unit definition for a given string
  static UnitDefinition? getDefinition(String? unit) {
    if (unit == null) return null;
    final normalized = unit.trim().toLowerCase();
    return _definitions[normalized];
  }

  /// Checks if two units are compatible for mathematical conversion and summation
  static bool areCompatible(String? unit1, String? unit2) {
    if (unit1 == null && unit2 == null) return true;
    if (unit1 == null || unit2 == null) return false;

    final u1 = unit1.trim().toLowerCase();
    final u2 = unit2.trim().toLowerCase();
    if (u1 == u2) return true;

    final def1 = getDefinition(u1);
    final def2 = getDefinition(u2);

    if (def1 != null && def2 != null) {
      // In count dimension, subcategories like 'slices' vs 'piece' should not merge
      if (def1.dimension == UnitDimension.count) {
        return def1.canonicalUnit == def2.canonicalUnit;
      }
      return def1.dimension == def2.dimension;
    }

    return false;
  }

  /// Sums two quantities with compatible units and selects the best representation.
  /// Returns a record of `(summedQuantity, targetUnit)`.
  /// Returns null if units are incompatible.
  static ({double quantity, String? unit})? sumCompatible({
    required double? q1,
    required String? u1,
    required double? q2,
    required String? u2,
  }) {
    final qty1 = q1 ?? 0.0;
    final qty2 = q2 ?? 0.0;

    // Both without units
    if ((u1 == null || u1.isEmpty) && (u2 == null || u2.isEmpty)) {
      return (quantity: qty1 + qty2, unit: null);
    }

    final def1 = getDefinition(u1);
    final def2 = getDefinition(u2);

    // Exact string match or both unknown but identical
    final norm1 = u1?.trim().toLowerCase();
    final norm2 = u2?.trim().toLowerCase();
    if (norm1 == norm2 && (def1 == null || def2 == null)) {
      return (quantity: qty1 + qty2, unit: u1);
    }

    if (def1 == null || def2 == null || def1.dimension != def2.dimension) {
      return null;
    }

    // Both share the same dimension
    switch (def1.dimension) {
      case UnitDimension.mass:
        final totalGrams =
            (qty1 * def1.factorToBase) + (qty2 * def2.factorToBase);
        // If either unit was kg or total grams >= 1000, express in kg
        final eitherKg = def1.canonicalUnit == 'kg' || def2.canonicalUnit == 'kg';
        if (eitherKg || totalGrams >= 1000.0) {
          final kg = totalGrams / 1000.0;
          return (quantity: _roundSmart(kg), unit: 'kg');
        } else {
          return (quantity: _roundSmart(totalGrams), unit: 'g');
        }

      case UnitDimension.metricVolume:
        final totalMl =
            (qty1 * def1.factorToBase) + (qty2 * def2.factorToBase);
        final eitherL = def1.canonicalUnit == 'l' || def2.canonicalUnit == 'l';
        if (eitherL || totalMl >= 1000.0) {
          final l = totalMl / 1000.0;
          return (quantity: _roundSmart(l), unit: 'l');
        } else {
          return (quantity: _roundSmart(totalMl), unit: 'ml');
        }

      case UnitDimension.culinaryVolume:
        // If both are cups
        if (def1.canonicalUnit == 'cup' && def2.canonicalUnit == 'cup') {
          return (quantity: _roundSmart(qty1 + qty2), unit: 'cup');
        }
        // If both are tbsp
        if (def1.canonicalUnit == 'tbsp' && def2.canonicalUnit == 'tbsp') {
          return (quantity: _roundSmart(qty1 + qty2), unit: 'tbsp');
        }
        // If both are tsp
        if (def1.canonicalUnit == 'tsp' && def2.canonicalUnit == 'tsp') {
          return (quantity: _roundSmart(qty1 + qty2), unit: 'tsp');
        }

        // Mixed culinary volume: convert to tsp base
        final totalTsp =
            (qty1 * def1.factorToBase) + (qty2 * def2.factorToBase);

        // If fits nicely into cups (multiple of 24 tsp = 0.5 cup or 48 tsp = 1 cup)
        if (totalTsp >= 24.0 && (totalTsp % 24.0 < 0.001)) {
          return (quantity: _roundSmart(totalTsp / 48.0), unit: 'cup');
        }

        // If divisible by 3 tsp (1 tbsp)
        if (totalTsp >= 3.0 && (totalTsp % 3.0 < 0.001)) {
          return (quantity: _roundSmart(totalTsp / 3.0), unit: 'tbsp');
        }

        // If either was tbsp, express as tbsp fraction if >= 3
        if ((def1.canonicalUnit == 'tbsp' || def2.canonicalUnit == 'tbsp') &&
            totalTsp >= 3.0) {
          return (quantity: _roundSmart(totalTsp / 3.0), unit: 'tbsp');
        }

        return (quantity: _roundSmart(totalTsp), unit: 'tsp');

      case UnitDimension.count:
        // Must match canonicalUnit (e.g. piece with piece, slices with slices)
        if (def1.canonicalUnit != def2.canonicalUnit) {
          return null;
        }
        return (
          quantity: _roundSmart(qty1 + qty2),
          unit: def1.canonicalUnit,
        );

      case UnitDimension.other:
        if (norm1 == norm2) {
          return (quantity: _roundSmart(qty1 + qty2), unit: u1);
        }
        return null;
    }
  }

  /// Formats unit name to localized Arabic string
  static String formatUnitAr(String? unit) {
    if (unit == null || unit.isEmpty) return '';
    final def = getDefinition(unit);
    if (def != null) return def.arabicName;

    return switch (unit.toLowerCase()) {
      'tbsp' => 'ملعقة كبيرة',
      'tsp' => 'ملعقة صغيرة',
      'cup' => 'كوب',
      'cups' => 'أكواب',
      'piece' => 'حبة',
      'pieces' => 'حبات',
      'slices' => 'شرائح',
      'slice' => 'شريحة',
      'leaves' => 'أوراق',
      'leaf' => 'ورقة',
      'g' => 'جرام',
      'kg' => 'كجم',
      'ml' => 'مل',
      'l' => 'لتر',
      'can' => 'علبة',
      'cans' => 'علب',
      'pinch' => 'رشة',
      _ => unit,
    };
  }

  static double _roundSmart(double value) {
    // Round to 2 decimal places to avoid floating point precision artifacts like 0.30000000000000004
    return (value * 100).roundToDouble() / 100.0;
  }
}

/// Service that handles duplicate detection, quantity summing, and merging of grocery items
class GroceryMerger {
  const GroceryMerger._();

  /// Merges a batch of new [GroceryItem]s into [existing] grocery items list.
  ///
  /// Rules:
  /// - Matches existing items by `ingredientId` (or trimmed lowercase `nameAr` for manual entries).
  /// - Sums quantities if units are compatible.
  /// - If units are incompatible, preserves both as distinct entries.
  /// - Unchecks the item if new quantity is added so the user knows to buy it.
  /// - Appends new unique items.
  static List<GroceryItem> mergeItems({
    required List<GroceryItem> existing,
    required List<GroceryItem> incoming,
  }) {
    final result = List<GroceryItem>.from(existing);

    for (final newItem in incoming) {
      // Find matching item in result
      final matchIndex = result.indexWhere((it) {
        if (it.ingredientId.isNotEmpty &&
            newItem.ingredientId.isNotEmpty &&
            !it.ingredientId.startsWith('manual_') &&
            !newItem.ingredientId.startsWith('manual_')) {
          return it.ingredientId == newItem.ingredientId;
        }
        // Fallback matching for manual items by name
        return it.nameAr.trim().toLowerCase() ==
            newItem.nameAr.trim().toLowerCase();
      });

      if (matchIndex >= 0) {
        final existingItem = result[matchIndex];

        // Attempt unit conversion and summation
        final sumResult = UnitConverter.sumCompatible(
          q1: existingItem.quantity,
          u1: existingItem.unit,
          q2: newItem.quantity,
          u2: newItem.unit,
        );

        if (sumResult != null) {
          // Compatible: merge into existing item
          final mergedRecipeIds = <String>{};
          if (existingItem.recipeId != null) {
            mergedRecipeIds.addAll(
              existingItem.recipeId!.split(',').map((s) => s.trim()),
            );
          }
          if (newItem.recipeId != null) {
            mergedRecipeIds.addAll(
              newItem.recipeId!.split(',').map((s) => s.trim()),
            );
          }

          result[matchIndex] = existingItem.copyWith(
            quantity: sumResult.quantity,
            unit: sumResult.unit,
            isChecked: false, // reset check state when re-added
            recipeId: mergedRecipeIds.isNotEmpty
                ? mergedRecipeIds.join(', ')
                : null,
          );
          continue;
        }
      }

      // If no match found or units incompatible, append as separate item
      result.add(newItem);
    }

    return result;
  }

  /// Converts missing ingredients from a recipe (scaled by [targetServings]) into [GroceryItem] models.
  static List<GroceryItem> buildItemsFromRecipe({
    required Recipe recipe,
    required int targetServings,
    required Set<String> tickedIngredientIds,
    required Map<String, Ingredient> ingredientMasterMap,
  }) {
    final scaleFactor =
        (recipe.servings > 0) ? (targetServings / recipe.servings) : 1.0;
    final items = <GroceryItem>[];

    for (final ing in recipe.ingredients) {
      // 1. Skip if already ticked ("I have it")
      if (tickedIngredientIds.contains(ing.ingredientId)) {
        continue;
      }

      final canonical = ingredientMasterMap[ing.ingredientId];
      final scaledQty = ing.quantity != null
          ? UnitConverter._roundSmart(ing.quantity! * scaleFactor)
          : null;

      final nameAr = canonical?.nameAr ?? ing.displayText ?? ing.ingredientId;
      final nameEn = canonical?.nameEn ?? ing.ingredientId;
      final aisle = canonical?.category ?? 'other';

      final item = GroceryItem(
        id: 'grocery_${recipe.id}_${ing.ingredientId}',
        ingredientId: ing.ingredientId,
        nameAr: nameAr,
        nameEn: nameEn,
        aisle: aisle,
        quantity: scaledQty,
        unit: ing.unit,
        isChecked: false,
        recipeId: recipe.id,
      );

      items.add(item);
    }

    return items;
  }
}
