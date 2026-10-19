// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_suggestion_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealSuggestionRequest _$MealSuggestionRequestFromJson(
  Map<String, dynamic> json,
) => _MealSuggestionRequest(
  selectedKids: (json['selectedKids'] as List<dynamic>)
      .map((e) => KidProfile.fromJson(e as Map<String, dynamic>))
      .toList(),
  availableIngredientIds: (json['availableIngredientIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  maxMinutes: (json['maxMinutes'] as num?)?.toInt(),
  mealType: json['mealType'] as String? ?? 'lunchbox',
  moodTags:
      (json['moodTags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  freeTextNote: json['freeTextNote'] as String?,
);

Map<String, dynamic> _$MealSuggestionRequestToJson(
  _MealSuggestionRequest instance,
) => <String, dynamic>{
  'selectedKids': instance.selectedKids,
  'availableIngredientIds': instance.availableIngredientIds,
  'maxMinutes': instance.maxMinutes,
  'mealType': instance.mealType,
  'moodTags': instance.moodTags,
  'freeTextNote': instance.freeTextNote,
};
