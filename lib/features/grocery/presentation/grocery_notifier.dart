import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_merger.dart';

/// Provider for managing the persistent Grocery list
final groceryListNotifierProvider =
    AsyncNotifierProvider<GroceryListNotifier, List<GroceryItem>>(
      GroceryListNotifier.new,
    );

class GroceryListNotifier extends AsyncNotifier<List<GroceryItem>> {
  @override
  Future<List<GroceryItem>> build() async {
    final dao = ref.watch(groceryDaoProvider);
    return dao.getAllItems();
  }

  /// Adds un-ticked ingredients from a recipe, scaling quantities by [targetServings],
  /// merging duplicates and summing compatible units.
  /// Returns the number of new/merged items added.
  Future<int> addMissingFromRecipe({
    required Recipe recipe,
    required int targetServings,
    required Set<String> tickedIngredientIds,
  }) async {
    final dao = ref.read(groceryDaoProvider);
    final ingredientsDao = ref.read(ingredientsDaoProvider);

    // 1. Load canonical ingredients dictionary
    final allIngredients = await ingredientsDao.getAllIngredients();
    final ingredientMap = <String, Ingredient>{
      for (final ing in allIngredients) ing.id: ing,
    };

    // 2. Build incoming items for missing ingredients
    final incomingItems = GroceryMerger.buildItemsFromRecipe(
      recipe: recipe,
      targetServings: targetServings,
      tickedIngredientIds: tickedIngredientIds,
      ingredientMasterMap: ingredientMap,
    );

    if (incomingItems.isEmpty) {
      return 0;
    }

    // 3. Load current items and merge
    final currentItems = await dao.getAllItems();
    final merged = GroceryMerger.mergeItems(
      existing: currentItems,
      incoming: incomingItems,
    );

    // 4. Persist to Drift database
    await dao.clearAllItems();
    await dao.insertItems(merged);

    // 5. Update state
    state = AsyncData(merged);

    return incomingItems.length;
  }

  /// Toggles the checked status of a grocery item
  Future<void> toggleItem(String id) async {
    final currentList = state.value ?? [];
    final index = currentList.indexWhere((it) => it.id == id);
    if (index == -1) return;

    final target = currentList[index];
    final newChecked = !target.isChecked;

    final updated = List<GroceryItem>.from(currentList);
    updated[index] = target.copyWith(isChecked: newChecked);
    state = AsyncData(updated);

    final dao = ref.read(groceryDaoProvider);
    await dao.toggleItem(id, newChecked);
  }

  /// Deletes an item from the grocery list
  Future<void> deleteItem(String id) async {
    final currentList = state.value ?? [];
    final updated = currentList.where((it) => it.id != id).toList();
    state = AsyncData(updated);

    final dao = ref.read(groceryDaoProvider);
    await dao.deleteItem(id);
  }

  /// Restores a deleted item (useful for undo actions)
  Future<void> restoreItem(GroceryItem item) async {
    final currentList = state.value ?? [];
    final updated = [...currentList, item];
    state = AsyncData(updated);

    final dao = ref.read(groceryDaoProvider);
    await dao.insertItem(item);
  }

  /// Adds a custom manual grocery item
  Future<void> addManualItem({
    required String nameAr,
    String? nameEn,
    double? quantity,
    String? unit,
    required String aisle,
  }) async {
    final dao = ref.read(groceryDaoProvider);
    final currentList = state.value ?? await dao.getAllItems();

    final newItem = GroceryItem(
      id: 'manual_${DateTime.now().microsecondsSinceEpoch}',
      ingredientId: 'manual_${DateTime.now().microsecondsSinceEpoch}',
      nameAr: nameAr.trim(),
      nameEn: nameEn?.trim().isNotEmpty == true
          ? nameEn!.trim()
          : nameAr.trim(),
      aisle: aisle,
      quantity: quantity,
      unit: unit?.trim().isNotEmpty == true ? unit!.trim() : null,
      isChecked: false,
    );

    final merged = GroceryMerger.mergeItems(
      existing: currentList,
      incoming: [newItem],
    );

    await dao.clearAllItems();
    await dao.insertItems(merged);

    state = AsyncData(merged);
  }

  /// Clears only checked/purchased items
  Future<void> clearChecked() async {
    final dao = ref.read(groceryDaoProvider);
    await dao.deleteCheckedItems();
    final remaining = await dao.getAllItems();
    state = AsyncData(remaining);
  }

  /// Clears all grocery items
  Future<void> clearAll() async {
    final dao = ref.read(groceryDaoProvider);
    await dao.clearAllItems();
    state = const AsyncData([]);
  }
}
