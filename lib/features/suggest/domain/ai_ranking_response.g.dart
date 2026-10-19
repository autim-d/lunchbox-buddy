// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_ranking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiRankedItem _$AiRankedItemFromJson(Map<String, dynamic> json) =>
    _AiRankedItem(
      recipeId: json['recipeId'] as String,
      reasonAr: json['reasonAr'] as String,
      substitutionTip: json['substitutionTip'] as String?,
    );

Map<String, dynamic> _$AiRankedItemToJson(_AiRankedItem instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'reasonAr': instance.reasonAr,
      'substitutionTip': instance.substitutionTip,
    };

_AiRankingResponse _$AiRankingResponseFromJson(Map<String, dynamic> json) =>
    _AiRankingResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => AiRankedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AiRankedItem>[],
    );

Map<String, dynamic> _$AiRankingResponseToJson(_AiRankingResponse instance) =>
    <String, dynamic>{'items': instance.items};
