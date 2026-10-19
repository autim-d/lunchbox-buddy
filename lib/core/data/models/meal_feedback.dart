import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_feedback.freezed.dart';
part 'meal_feedback.g.dart';

@freezed
abstract class MealFeedback with _$MealFeedback {
  const factory MealFeedback({
    required String id,
    required String recipeId,
    String? kidId,
    required String reaction, // 'loved', 'ok', 'refused'
    String? reasonTag,
    required DateTime date,
    String? notes,
  }) = _MealFeedback;

  factory MealFeedback.fromJson(Map<String, dynamic> json) =>
      _$MealFeedbackFromJson(json);
}
