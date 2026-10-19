import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    required String description,
    required List<RecipeIngredient> ingredients,
    required List<String> steps,
    required int prepMinutes,
    required int cookMinutes,
    @Default(1) int servings,
    @Default(<String>[]) List<String> tags,
    @Default('curated') String source,
    @Default(12) int ageMinMonths,
    String? imagePath,
    @Default(1) int safetyVersion,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
