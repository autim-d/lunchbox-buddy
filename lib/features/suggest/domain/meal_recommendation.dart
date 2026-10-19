import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';

part 'meal_recommendation.freezed.dart';
part 'meal_recommendation.g.dart';

@freezed
abstract class MealRecommendation with _$MealRecommendation {
  const factory MealRecommendation({
    required Recipe recipe,
    required double score,
    required String reasonKey,
    @Default(<String, double>{}) Map<String, double> breakdown,
    String? aiReason,
    String? substitutionTip,
    @Default(false) bool isAiRanked,
  }) = _MealRecommendation;

  factory MealRecommendation.fromJson(Map<String, dynamic> json) =>
      _$MealRecommendationFromJson(json);
}
