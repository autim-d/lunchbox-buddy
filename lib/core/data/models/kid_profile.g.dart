// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kid_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KidProfile _$KidProfileFromJson(Map<String, dynamic> json) => _KidProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  dislikes:
      (json['dislikes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  likes:
      (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  pickyLevel: (json['pickyLevel'] as num?)?.toInt() ?? 0,
  lunchboxType: json['lunchboxType'] as String? ?? 'none',
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$KidProfileToJson(_KidProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'allergies': instance.allergies,
      'dislikes': instance.dislikes,
      'likes': instance.likes,
      'pickyLevel': instance.pickyLevel,
      'lunchboxType': instance.lunchboxType,
      'notes': instance.notes,
    };
