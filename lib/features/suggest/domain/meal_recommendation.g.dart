// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealRecommendation _$MealRecommendationFromJson(Map<String, dynamic> json) =>
    _MealRecommendation(
      recipe: Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
      reasonKey: json['reasonKey'] as String,
      breakdown:
          (json['breakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      aiReason: json['aiReason'] as String?,
      substitutionTip: json['substitutionTip'] as String?,
      isAiRanked: json['isAiRanked'] as bool? ?? false,
    );

Map<String, dynamic> _$MealRecommendationToJson(_MealRecommendation instance) =>
    <String, dynamic>{
      'recipe': instance.recipe,
      'score': instance.score,
      'reasonKey': instance.reasonKey,
      'breakdown': instance.breakdown,
      'aiReason': instance.aiReason,
      'substitutionTip': instance.substitutionTip,
      'isAiRanked': instance.isAiRanked,
    };
