// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recipe {

 String get id; String get title; String get description; List<RecipeIngredient> get ingredients; List<String> get steps; int get prepMinutes; int get cookMinutes; int get servings; List<String> get tags; String get source; int get ageMinMonths; String? get imagePath; int get safetyVersion;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Recipe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients)&&const DeepCollectionEquality().equals(other.steps, _this.steps)&&(identical(other.prepMinutes, _this.prepMinutes) || other.prepMinutes == _this.prepMinutes)&&(identical(other.cookMinutes, _this.cookMinutes) || other.cookMinutes == _this.cookMinutes)&&(identical(other.servings, _this.servings) || other.servings == _this.servings)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.ageMinMonths, _this.ageMinMonths) || other.ageMinMonths == _this.ageMinMonths)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.safetyVersion, _this.safetyVersion) || other.safetyVersion == _this.safetyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Recipe;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,const DeepCollectionEquality().hash(_this.ingredients),const DeepCollectionEquality().hash(_this.steps),_this.prepMinutes,_this.cookMinutes,_this.servings,const DeepCollectionEquality().hash(_this.tags),_this.source,_this.ageMinMonths,_this.imagePath,_this.safetyVersion);
}

@override
String toString() {
  final _this = this as Recipe;
  return 'Recipe(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, ingredients: ${_this.ingredients}, steps: ${_this.steps}, prepMinutes: ${_this.prepMinutes}, cookMinutes: ${_this.cookMinutes}, servings: ${_this.servings}, tags: ${_this.tags}, source: ${_this.source}, ageMinMonths: ${_this.ageMinMonths}, imagePath: ${_this.imagePath}, safetyVersion: ${_this.safetyVersion})';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<RecipeIngredient> ingredients, List<String> steps, int prepMinutes, int cookMinutes, int servings, List<String> tags, String source, int ageMinMonths, String? imagePath, int safetyVersion
});




}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? ingredients = null,Object? steps = null,Object? prepMinutes = null,Object? cookMinutes = null,Object? servings = null,Object? tags = null,Object? source = null,Object? ageMinMonths = null,Object? imagePath = freezed,Object? safetyVersion = null,}) {
  return _then(Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,prepMinutes: null == prepMinutes ? _self.prepMinutes : prepMinutes // ignore: cast_nullable_to_non_nullable
as int,cookMinutes: null == cookMinutes ? _self.cookMinutes : cookMinutes // ignore: cast_nullable_to_non_nullable
as int,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,ageMinMonths: null == ageMinMonths ? _self.ageMinMonths : ageMinMonths // ignore: cast_nullable_to_non_nullable
as int,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,safetyVersion: null == safetyVersion ? _self.safetyVersion : safetyVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<RecipeIngredient> ingredients,  List<String> steps,  int prepMinutes,  int cookMinutes,  int servings,  List<String> tags,  String source,  int ageMinMonths,  String? imagePath,  int safetyVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.ingredients,_that.steps,_that.prepMinutes,_that.cookMinutes,_that.servings,_that.tags,_that.source,_that.ageMinMonths,_that.imagePath,_that.safetyVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<RecipeIngredient> ingredients,  List<String> steps,  int prepMinutes,  int cookMinutes,  int servings,  List<String> tags,  String source,  int ageMinMonths,  String? imagePath,  int safetyVersion)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.title,_that.description,_that.ingredients,_that.steps,_that.prepMinutes,_that.cookMinutes,_that.servings,_that.tags,_that.source,_that.ageMinMonths,_that.imagePath,_that.safetyVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<RecipeIngredient> ingredients,  List<String> steps,  int prepMinutes,  int cookMinutes,  int servings,  List<String> tags,  String source,  int ageMinMonths,  String? imagePath,  int safetyVersion)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.ingredients,_that.steps,_that.prepMinutes,_that.cookMinutes,_that.servings,_that.tags,_that.source,_that.ageMinMonths,_that.imagePath,_that.safetyVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe implements Recipe {
  const _Recipe({required this.id, required this.title, required this.description, required  List<RecipeIngredient> ingredients, required  List<String> steps, required this.prepMinutes, required this.cookMinutes, this.servings = 1,  List<String> tags = const <String>[], this.source = 'curated', this.ageMinMonths = 12, this.imagePath, this.safetyVersion = 1}): _ingredients = ingredients,_steps = steps,_tags = tags;
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<RecipeIngredient> _ingredients;
@override List<RecipeIngredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

 final  List<String> _steps;
@override List<String> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  int prepMinutes;
@override final  int cookMinutes;
@override@JsonKey() final  int servings;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  String source;
@override@JsonKey() final  int ageMinMonths;
@override final  String? imagePath;
@override@JsonKey() final  int safetyVersion;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients)&&const DeepCollectionEquality().equals(other.steps, _steps)&&(identical(other.prepMinutes, prepMinutes) || other.prepMinutes == prepMinutes)&&(identical(other.cookMinutes, cookMinutes) || other.cookMinutes == cookMinutes)&&(identical(other.servings, servings) || other.servings == servings)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.source, source) || other.source == source)&&(identical(other.ageMinMonths, ageMinMonths) || other.ageMinMonths == ageMinMonths)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.safetyVersion, safetyVersion) || other.safetyVersion == safetyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_steps),prepMinutes,cookMinutes,servings,const DeepCollectionEquality().hash(_tags),source,ageMinMonths,imagePath,safetyVersion);
}

@override
String toString() {
    return 'Recipe(id: $id, title: $title, description: $description, ingredients: $ingredients, steps: $steps, prepMinutes: $prepMinutes, cookMinutes: $cookMinutes, servings: $servings, tags: $tags, source: $source, ageMinMonths: $ageMinMonths, imagePath: $imagePath, safetyVersion: $safetyVersion)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<RecipeIngredient> ingredients, List<String> steps, int prepMinutes, int cookMinutes, int servings, List<String> tags, String source, int ageMinMonths, String? imagePath, int safetyVersion
});




}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? ingredients = null,Object? steps = null,Object? prepMinutes = null,Object? cookMinutes = null,Object? servings = null,Object? tags = null,Object? source = null,Object? ageMinMonths = null,Object? imagePath = freezed,Object? safetyVersion = null,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<RecipeIngredient>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,prepMinutes: null == prepMinutes ? _self.prepMinutes : prepMinutes // ignore: cast_nullable_to_non_nullable
as int,cookMinutes: null == cookMinutes ? _self.cookMinutes : cookMinutes // ignore: cast_nullable_to_non_nullable
as int,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,ageMinMonths: null == ageMinMonths ? _self.ageMinMonths : ageMinMonths // ignore: cast_nullable_to_non_nullable
as int,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,safetyVersion: null == safetyVersion ? _self.safetyVersion : safetyVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
