// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealRecommendation {

 Recipe get recipe; double get score; String get reasonKey; Map<String, double> get breakdown; String? get aiReason; String? get substitutionTip; bool get isAiRanked;
/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealRecommendationCopyWith<MealRecommendation> get copyWith => _$MealRecommendationCopyWithImpl<MealRecommendation>(this as MealRecommendation, _$identity);

  /// Serializes this MealRecommendation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MealRecommendation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealRecommendation&&(identical(other.recipe, _this.recipe) || other.recipe == _this.recipe)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.reasonKey, _this.reasonKey) || other.reasonKey == _this.reasonKey)&&const DeepCollectionEquality().equals(other.breakdown, _this.breakdown)&&(identical(other.aiReason, _this.aiReason) || other.aiReason == _this.aiReason)&&(identical(other.substitutionTip, _this.substitutionTip) || other.substitutionTip == _this.substitutionTip)&&(identical(other.isAiRanked, _this.isAiRanked) || other.isAiRanked == _this.isAiRanked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MealRecommendation;
  return Object.hash(runtimeType,_this.recipe,_this.score,_this.reasonKey,const DeepCollectionEquality().hash(_this.breakdown),_this.aiReason,_this.substitutionTip,_this.isAiRanked);
}

@override
String toString() {
  final _this = this as MealRecommendation;
  return 'MealRecommendation(recipe: ${_this.recipe}, score: ${_this.score}, reasonKey: ${_this.reasonKey}, breakdown: ${_this.breakdown}, aiReason: ${_this.aiReason}, substitutionTip: ${_this.substitutionTip}, isAiRanked: ${_this.isAiRanked})';
}


}

/// @nodoc
abstract mixin class $MealRecommendationCopyWith<$Res>  {
  factory $MealRecommendationCopyWith(MealRecommendation value, $Res Function(MealRecommendation) _then) = _$MealRecommendationCopyWithImpl;
@useResult
$Res call({
 Recipe recipe, double score, String reasonKey, Map<String, double> breakdown, String? aiReason, String? substitutionTip, bool isAiRanked
});


$RecipeCopyWith<$Res> get recipe;

}
/// @nodoc
class _$MealRecommendationCopyWithImpl<$Res>
    implements $MealRecommendationCopyWith<$Res> {
  _$MealRecommendationCopyWithImpl(this._self, this._then);

  final MealRecommendation _self;
  final $Res Function(MealRecommendation) _then;

/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipe = null,Object? score = null,Object? reasonKey = null,Object? breakdown = null,Object? aiReason = freezed,Object? substitutionTip = freezed,Object? isAiRanked = null,}) {
  return _then(MealRecommendation(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as Recipe,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,aiReason: freezed == aiReason ? _self.aiReason : aiReason // ignore: cast_nullable_to_non_nullable
as String?,substitutionTip: freezed == substitutionTip ? _self.substitutionTip : substitutionTip // ignore: cast_nullable_to_non_nullable
as String?,isAiRanked: null == isAiRanked ? _self.isAiRanked : isAiRanked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res> get recipe {
  
  return $RecipeCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}


/// Adds pattern-matching-related methods to [MealRecommendation].
extension MealRecommendationPatterns on MealRecommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealRecommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealRecommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealRecommendation value)  $default,){
final _that = this;
switch (_that) {
case _MealRecommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealRecommendation value)?  $default,){
final _that = this;
switch (_that) {
case _MealRecommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Recipe recipe,  double score,  String reasonKey,  Map<String, double> breakdown,  String? aiReason,  String? substitutionTip,  bool isAiRanked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealRecommendation() when $default != null:
return $default(_that.recipe,_that.score,_that.reasonKey,_that.breakdown,_that.aiReason,_that.substitutionTip,_that.isAiRanked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Recipe recipe,  double score,  String reasonKey,  Map<String, double> breakdown,  String? aiReason,  String? substitutionTip,  bool isAiRanked)  $default,) {final _that = this;
switch (_that) {
case _MealRecommendation():
return $default(_that.recipe,_that.score,_that.reasonKey,_that.breakdown,_that.aiReason,_that.substitutionTip,_that.isAiRanked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Recipe recipe,  double score,  String reasonKey,  Map<String, double> breakdown,  String? aiReason,  String? substitutionTip,  bool isAiRanked)?  $default,) {final _that = this;
switch (_that) {
case _MealRecommendation() when $default != null:
return $default(_that.recipe,_that.score,_that.reasonKey,_that.breakdown,_that.aiReason,_that.substitutionTip,_that.isAiRanked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealRecommendation implements MealRecommendation {
  const _MealRecommendation({required this.recipe, required this.score, required this.reasonKey,  Map<String, double> breakdown = const <String, double>{}, this.aiReason, this.substitutionTip, this.isAiRanked = false}): _breakdown = breakdown;
  factory _MealRecommendation.fromJson(Map<String, dynamic> json) => _$MealRecommendationFromJson(json);

@override final  Recipe recipe;
@override final  double score;
@override final  String reasonKey;
 final  Map<String, double> _breakdown;
@override@JsonKey() Map<String, double> get breakdown {
  if (_breakdown is EqualUnmodifiableMapView) return _breakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_breakdown);
}

@override final  String? aiReason;
@override final  String? substitutionTip;
@override@JsonKey() final  bool isAiRanked;

/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealRecommendationCopyWith<_MealRecommendation> get copyWith => __$MealRecommendationCopyWithImpl<_MealRecommendation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealRecommendationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealRecommendation&&(identical(other.recipe, recipe) || other.recipe == recipe)&&(identical(other.score, score) || other.score == score)&&(identical(other.reasonKey, reasonKey) || other.reasonKey == reasonKey)&&const DeepCollectionEquality().equals(other.breakdown, _breakdown)&&(identical(other.aiReason, aiReason) || other.aiReason == aiReason)&&(identical(other.substitutionTip, substitutionTip) || other.substitutionTip == substitutionTip)&&(identical(other.isAiRanked, isAiRanked) || other.isAiRanked == isAiRanked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recipe,score,reasonKey,const DeepCollectionEquality().hash(_breakdown),aiReason,substitutionTip,isAiRanked);
}

@override
String toString() {
    return 'MealRecommendation(recipe: $recipe, score: $score, reasonKey: $reasonKey, breakdown: $breakdown, aiReason: $aiReason, substitutionTip: $substitutionTip, isAiRanked: $isAiRanked)';
}


}

/// @nodoc
abstract mixin class _$MealRecommendationCopyWith<$Res> implements $MealRecommendationCopyWith<$Res> {
  factory _$MealRecommendationCopyWith(_MealRecommendation value, $Res Function(_MealRecommendation) _then) = __$MealRecommendationCopyWithImpl;
@override @useResult
$Res call({
 Recipe recipe, double score, String reasonKey, Map<String, double> breakdown, String? aiReason, String? substitutionTip, bool isAiRanked
});


@override $RecipeCopyWith<$Res> get recipe;

}
/// @nodoc
class __$MealRecommendationCopyWithImpl<$Res>
    implements _$MealRecommendationCopyWith<$Res> {
  __$MealRecommendationCopyWithImpl(this._self, this._then);

  final _MealRecommendation _self;
  final $Res Function(_MealRecommendation) _then;

/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipe = null,Object? score = null,Object? reasonKey = null,Object? breakdown = null,Object? aiReason = freezed,Object? substitutionTip = freezed,Object? isAiRanked = null,}) {
  return _then(_MealRecommendation(
recipe: null == recipe ? _self.recipe : recipe // ignore: cast_nullable_to_non_nullable
as Recipe,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,breakdown: null == breakdown ? _self._breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,aiReason: freezed == aiReason ? _self.aiReason : aiReason // ignore: cast_nullable_to_non_nullable
as String?,substitutionTip: freezed == substitutionTip ? _self.substitutionTip : substitutionTip // ignore: cast_nullable_to_non_nullable
as String?,isAiRanked: null == isAiRanked ? _self.isAiRanked : isAiRanked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MealRecommendation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipeCopyWith<$Res> get recipe {
  
  return $RecipeCopyWith<$Res>(_self.recipe, (value) {
    return _then(_self.copyWith(recipe: value));
  });
}
}

// dart format on
