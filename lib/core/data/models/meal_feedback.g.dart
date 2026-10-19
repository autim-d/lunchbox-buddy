// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealFeedback _$MealFeedbackFromJson(Map<String, dynamic> json) =>
    _MealFeedback(
      id: json['id'] as String,
      recipeId: json['recipeId'] as String,
      kidId: json['kidId'] as String?,
      reaction: json['reaction'] as String,
      reasonTag: json['reasonTag'] as String?,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MealFeedbackToJson(_MealFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipeId': instance.recipeId,
      'kidId': instance.kidId,
      'reaction': instance.reaction,
      'reasonTag': instance.reasonTag,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
    };
