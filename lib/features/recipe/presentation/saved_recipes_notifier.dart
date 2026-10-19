import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';

const _kSavedRecipesKey = 'saved_recipe_ids';

/// Notifier managing the Set of saved recipe IDs persisted in local SQLite metadata
class SavedRecipeIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  FutureOr<Set<String>> build() async {
    final metadataDao = ref.watch(metadataDaoProvider);
    final rawJson = await metadataDao.getValue(_kSavedRecipesKey);
    if (rawJson == null || rawJson.isEmpty) {
      return <String>{};
    }
    try {
      final list = jsonDecode(rawJson) as List<dynamic>;
      return list.map((e) => e.toString()).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> toggleSave(String recipeId) async {
    final currentSet = state.asData?.value ?? <String>{};
    final newSet = Set<String>.from(currentSet);
    if (newSet.contains(recipeId)) {
      newSet.remove(recipeId);
    } else {
      newSet.add(recipeId);
    }

    state = AsyncData(newSet);
    final metadataDao = ref.read(metadataDaoProvider);
    await metadataDao.setValue(_kSavedRecipesKey, jsonEncode(newSet.toList()));
  }

  Future<void> removeRecipe(String recipeId) async {
    final currentSet = state.asData?.value ?? <String>{};
    if (!currentSet.contains(recipeId)) return;
    final newSet = Set<String>.from(currentSet)..remove(recipeId);
    state = AsyncData(newSet);
    final metadataDao = ref.read(metadataDaoProvider);
    await metadataDao.setValue(_kSavedRecipesKey, jsonEncode(newSet.toList()));
  }

  Future<void> saveRecipe(String recipeId) async {
    final currentSet = state.asData?.value ?? <String>{};
    if (currentSet.contains(recipeId)) return;
    final newSet = Set<String>.from(currentSet)..add(recipeId);
    state = AsyncData(newSet);
    final metadataDao = ref.read(metadataDaoProvider);
    await metadataDao.setValue(_kSavedRecipesKey, jsonEncode(newSet.toList()));
  }

  bool isSaved(String recipeId) {
    return state.asData?.value.contains(recipeId) ?? false;
  }
}

final savedRecipeIdsProvider =
    AsyncNotifierProvider<SavedRecipeIdsNotifier, Set<String>>(
      SavedRecipeIdsNotifier.new,
    );

/// Provider resolving full Recipe objects for all saved IDs
final savedRecipesListProvider = FutureProvider<List<Recipe>>((ref) async {
  final savedIdsAsync = ref.watch(savedRecipeIdsProvider);
  final savedIds = savedIdsAsync.asData?.value ?? <String>{};
  if (savedIds.isEmpty) return const <Recipe>[];

  final recipesDao = ref.watch(recipesDaoProvider);
  final allRecipes = await recipesDao.getAllRecipes();
  return allRecipes.where((r) => savedIds.contains(r.id)).toList();
});

/// Provider resolving a single Recipe by its ID
final recipeByIdProvider = FutureProvider.family<Recipe?, String>((
  ref,
  recipeId,
) async {
  final recipesDao = ref.watch(recipesDaoProvider);
  return recipesDao.getRecipeById(recipeId);
});
