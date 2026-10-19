// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_parsed_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiParsedRequest _$AiParsedRequestFromJson(Map<String, dynamic> json) =>
    _AiParsedRequest(
      mealType: json['mealType'] as String? ?? 'lunchbox',
      maxMinutes: (json['maxMinutes'] as num?)?.toInt(),
      moodTags:
          (json['moodTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      availableIngredientIds:
          (json['availableIngredientIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      excludedIngredientIds:
          (json['excludedIngredientIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      unresolvedIngredients:
          (json['unresolvedIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      confidenceReason: json['confidenceReason'] as String?,
    );

Map<String, dynamic> _$AiParsedRequestToJson(_AiParsedRequest instance) =>
    <String, dynamic>{
      'mealType': instance.mealType,
      'maxMinutes': instance.maxMinutes,
      'moodTags': instance.moodTags,
      'availableIngredientIds': instance.availableIngredientIds,
      'excludedIngredientIds': instance.excludedIngredientIds,
      'unresolvedIngredients': instance.unresolvedIngredients,
      'confidenceReason': instance.confidenceReason,
    };
