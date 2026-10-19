import 'package:flutter/material.dart';
import 'package:lunchbox_buddy/core/l10n/l10n.dart';
import 'package:lunchbox_buddy/core/ui/chip_selector.dart';

/// Helpers for mapping canonical allergens and dislikes to localized UI chip items
abstract final class KidFormHelpers {
  /// Returns the canonical list of allergy chip items with localized labels
  static List<ChipItem> getAllergyChips(AppLocalizations l10n) {
    return [
      ChipItem(
        id: 'milk',
        label: l10n.allergenMilk,
        icon: Icons.local_drink_rounded,
      ),
      ChipItem(id: 'egg', label: l10n.allergenEgg, icon: Icons.egg_rounded),
      ChipItem(
        id: 'gluten',
        label: l10n.allergenGluten,
        icon: Icons.bakery_dining_rounded,
      ),
      ChipItem(
        id: 'peanut',
        label: l10n.allergenPeanuts,
        icon: Icons.grain_rounded,
      ),
      ChipItem(
        id: 'treenut',
        label: l10n.allergenNuts,
        icon: Icons.nature_rounded,
      ),
      ChipItem(
        id: 'sesame',
        label: l10n.allergenSesame,
        icon: Icons.circle_outlined,
      ),
      ChipItem(
        id: 'fish',
        label: l10n.allergenFish,
        icon: Icons.set_meal_rounded,
      ),
      ChipItem(
        id: 'shellfish',
        label: l10n.allergenShellfish,
        icon: Icons.water_drop_rounded,
      ),
      ChipItem(id: 'soy', label: l10n.allergenSoy, icon: Icons.spa_rounded),
    ];
  }

  /// Returns dislike chip items from the canonical ingredient list with localized labels
  static List<ChipItem> getDislikeChips(AppLocalizations l10n) {
    return [
      ChipItem(
        id: 'cucumber',
        label: l10n.dislikeCucumber,
        icon: Icons.eco_rounded,
      ),
      ChipItem(
        id: 'tomato',
        label: l10n.dislikeTomato,
        icon: Icons.circle_rounded,
      ),
      ChipItem(
        id: 'carrot',
        label: l10n.dislikeCarrot,
        icon: Icons.edit_road_rounded,
      ),
      ChipItem(
        id: 'bell_pepper',
        label: l10n.dislikeBellPepper,
        icon: Icons.flare_rounded,
      ),
      ChipItem(
        id: 'onion',
        label: l10n.dislikeOnion,
        icon: Icons.lens_blur_rounded,
      ),
      ChipItem(
        id: 'garlic',
        label: l10n.dislikeGarlic,
        icon: Icons.bubble_chart_rounded,
      ),
      ChipItem(
        id: 'tuna',
        label: l10n.dislikeTuna,
        icon: Icons.set_meal_rounded,
      ),
      ChipItem(id: 'peas', label: l10n.dislikePeas, icon: Icons.grain_rounded),
      ChipItem(
        id: 'olives',
        label: l10n.dislikeOlives,
        icon: Icons.circle_outlined,
      ),
      ChipItem(
        id: 'foul',
        label: l10n.dislikeFoul,
        icon: Icons.soup_kitchen_rounded,
      ),
      ChipItem(
        id: 'corn',
        label: l10n.dislikeCorn,
        icon: Icons.local_florist_rounded,
      ),
      ChipItem(
        id: 'lettuce',
        label: l10n.dislikeLettuce,
        icon: Icons.grass_rounded,
      ),
    ];
  }

  /// Formats an allergen ID into its localized readable label
  static String formatAllergyLabel(String id, AppLocalizations l10n) {
    return switch (id) {
      'milk' => l10n.allergenMilk,
      'egg' => l10n.allergenEgg,
      'gluten' => l10n.allergenGluten,
      'peanut' => l10n.allergenPeanuts,
      'treenut' => l10n.allergenNuts,
      'sesame' => l10n.allergenSesame,
      'fish' => l10n.allergenFish,
      'shellfish' => l10n.allergenShellfish,
      'soy' => l10n.allergenSoy,
      _ => id,
    };
  }

  /// Formats a canonical ingredient ID into its localized readable label
  static String formatDislikeLabel(String id, AppLocalizations l10n) {
    return switch (id) {
      'cucumber' => l10n.dislikeCucumber,
      'tomato' => l10n.dislikeTomato,
      'carrot' => l10n.dislikeCarrot,
      'bell_pepper' => l10n.dislikeBellPepper,
      'onion' => l10n.dislikeOnion,
      'garlic' => l10n.dislikeGarlic,
      'tuna' => l10n.dislikeTuna,
      'peas' => l10n.dislikePeas,
      'olives' => l10n.dislikeOlives,
      'foul' => l10n.dislikeFoul,
      'corn' => l10n.dislikeCorn,
      'lettuce' => l10n.dislikeLettuce,
      _ => id,
    };
  }
}
