// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
  prepMinutes: (json['prepMinutes'] as num).toInt(),
  cookMinutes: (json['cookMinutes'] as num).toInt(),
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  source: json['source'] as String? ?? 'curated',
  ageMinMonths: (json['ageMinMonths'] as num?)?.toInt() ?? 12,
  imagePath: json['imagePath'] as String?,
  safetyVersion: (json['safetyVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
  'prepMinutes': instance.prepMinutes,
  'cookMinutes': instance.cookMinutes,
  'servings': instance.servings,
  'tags': instance.tags,
  'source': instance.source,
  'ageMinMonths': instance.ageMinMonths,
  'imagePath': instance.imagePath,
  'safetyVersion': instance.safetyVersion,
};
