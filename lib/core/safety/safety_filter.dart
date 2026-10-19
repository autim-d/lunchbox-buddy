import 'dart:math';

import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';

/// Result of a safety check on a recipe
class SafetyResult {
  const SafetyResult({
    required this.isSafe,
    this.rejectionReasons = const [],
    this.offendingAllergens = const {},
  });

  final bool isSafe;
  final List<String> rejectionReasons;
  final Set<String> offendingAllergens;

  static const safe = SafetyResult(isSafe: true);
}

/// Deterministic safety filter enforcing zero-AI safety guarantees:
/// 1. Removes any recipe containing an allergen of any selected child.
/// 2. Removes any recipe exceeding the age guidance of the youngest child.
/// 3. Forbids honey for infants (< 12 months) due to infant botulism risk.
/// 4. Forbids whole nuts for toddlers (< 36 months) due to choking hazards.
class SafetyFilter {
  const SafetyFilter();

  /// Calculates age in months from birthDate to referenceDate (defaults to now)
  int calculateAgeInMonths(DateTime birthDate, [DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      months--;
    }
    return months < 0 ? 0 : months;
  }

  /// Normalizes an allergen identifier into a canonical set of equivalent allergens.
  /// For instance, tree nuts and peanuts are reciprocally protected when "nuts" is specified.
  Set<String> normalizeAllergen(String allergen) {
    final lower = allergen.toLowerCase().trim();
    if (lower == 'peanut' || lower == 'peanuts') {
      return const {'peanut', 'peanuts'};
    }
    if (lower == 'treenut' ||
        lower == 'treenuts' ||
        lower == 'nuts' ||
        lower == 'nut') {
      // Under medical safety guidelines, general nut allergy covers peanuts & tree nuts
      return const {'treenut', 'treenuts', 'nuts', 'nut', 'peanut', 'peanuts'};
    }
    return {lower};
  }

  /// Checks if a single recipe is safe for all selected children
  SafetyResult checkRecipe({
    required Recipe recipe,
    required List<KidProfile> kids,
    required Map<String, Ingredient> ingredientMap,
    DateTime? referenceDate,
  }) {
    if (kids.isEmpty) {
      return SafetyResult.safe;
    }

    final rejectionReasons = <String>[];
    final offendingAllergens = <String>{};

    // 1. Gather all normalized allergens from all selected children
    final kidAllergens = <String>{};
    for (final kid in kids) {
      for (final allergy in kid.allergies) {
        kidAllergens.addAll(normalizeAllergen(allergy));
      }
    }

    // 2. Check each recipe ingredient against the kids' allergens
    for (final recipeIngredient in recipe.ingredients) {
      final ingredient = ingredientMap[recipeIngredient.ingredientId];
      if (ingredient != null) {
        for (final ingredientAllergen in ingredient.allergens) {
          final normalizedIngredientAllergens = normalizeAllergen(
            ingredientAllergen,
          );
          for (final normalizedIngAllergen in normalizedIngredientAllergens) {
            if (kidAllergens.contains(normalizedIngAllergen)) {
              offendingAllergens.add(ingredientAllergen);
              rejectionReasons.add(
                'Contains allergen "$ingredientAllergen" from ingredient "${ingredient.id}"',
              );
            }
          }
        }
      }
    }

    // 3. Age Guidance Check against the youngest child
    final youngestKidAgeMonths = kids
        .map((k) => calculateAgeInMonths(k.birthDate, referenceDate))
        .reduce(min);

    if (recipe.ageMinMonths > youngestKidAgeMonths) {
      rejectionReasons.add(
        'Recipe minimum age (${recipe.ageMinMonths}m) exceeds child age ($youngestKidAgeMonths m)',
      );
    }

    // 4. Special pediatric safety rules:
    // Infant Botulism Risk: Honey is strictly forbidden under 12 months
    if (youngestKidAgeMonths < 12) {
      final hasHoney = recipe.ingredients.any(
        (ing) => ing.ingredientId == 'honey',
      );
      if (hasHoney) {
        rejectionReasons.add(
          'Honey is strictly forbidden for infants under 12 months (botulism hazard)',
        );
      }
    }

    // Choking hazard: Whole nuts forbidden under 36 months
    if (youngestKidAgeMonths < 36) {
      final hasWholeNuts = recipe.ingredients.any(
        (ing) => ing.ingredientId == 'almonds' || ing.ingredientId == 'walnuts',
      );
      if (hasWholeNuts) {
        rejectionReasons.add(
          'Whole nuts are choking hazards for toddlers under 36 months',
        );
      }
    }

    if (rejectionReasons.isNotEmpty) {
      return SafetyResult(
        isSafe: false,
        rejectionReasons: rejectionReasons,
        offendingAllergens: offendingAllergens,
      );
    }

    return SafetyResult.safe;
  }

  /// Filters a list of recipes, returning only those that pass all safety checks
  List<Recipe> filterSafeRecipes({
    required List<Recipe> recipes,
    required List<KidProfile> kids,
    required Map<String, Ingredient> ingredientMap,
    DateTime? referenceDate,
  }) {
    return recipes.where((recipe) {
      final result = checkRecipe(
        recipe: recipe,
        kids: kids,
        ingredientMap: ingredientMap,
        referenceDate: referenceDate,
      );
      return result.isSafe;
    }).toList();
  }
}
