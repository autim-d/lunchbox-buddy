// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroceryItem _$GroceryItemFromJson(Map<String, dynamic> json) => _GroceryItem(
  id: json['id'] as String,
  ingredientId: json['ingredientId'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  aisle: json['aisle'] as String,
  quantity: (json['quantity'] as num?)?.toDouble(),
  unit: json['unit'] as String?,
  isChecked: json['isChecked'] as bool? ?? false,
  recipeId: json['recipeId'] as String?,
);

Map<String, dynamic> _$GroceryItemToJson(_GroceryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredientId': instance.ingredientId,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'aisle': instance.aisle,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'isChecked': instance.isChecked,
      'recipeId': instance.recipeId,
    };
