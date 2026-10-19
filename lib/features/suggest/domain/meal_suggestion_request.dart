import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';

part 'meal_suggestion_request.freezed.dart';
part 'meal_suggestion_request.g.dart';

@freezed
abstract class MealSuggestionRequest with _$MealSuggestionRequest {
  const factory MealSuggestionRequest({
    required List<KidProfile> selectedKids,
    List<String>? availableIngredientIds,
    int? maxMinutes,
    @Default('lunchbox') String mealType,
    @Default(<String>[]) List<String> moodTags,
    String? freeTextNote,
  }) = _MealSuggestionRequest;

  factory MealSuggestionRequest.fromJson(Map<String, dynamic> json) =>
      _$MealSuggestionRequestFromJson(json);
}
