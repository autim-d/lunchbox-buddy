import 'package:freezed_annotation/freezed_annotation.dart';

part 'grocery_item.freezed.dart';
part 'grocery_item.g.dart';

@freezed
abstract class GroceryItem with _$GroceryItem {
  const factory GroceryItem({
    required String id,
    required String ingredientId,
    required String nameAr,
    required String nameEn,
    required String aisle,
    double? quantity,
    String? unit,
    @Default(false) bool isChecked,
    String? recipeId,
  }) = _GroceryItem;

  factory GroceryItem.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemFromJson(json);
}
