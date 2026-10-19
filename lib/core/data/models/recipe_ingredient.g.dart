// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    _RecipeIngredient(
      ingredientId: json['ingredientId'] as String,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      displayText: json['displayText'] as String?,
      optional: json['optional'] as bool? ?? false,
    );

Map<String, dynamic> _$RecipeIngredientToJson(_RecipeIngredient instance) =>
    <String, dynamic>{
      'ingredientId': instance.ingredientId,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'displayText': instance.displayText,
      'optional': instance.optional,
    };
