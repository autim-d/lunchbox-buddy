// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_parsed_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiParsedRequest {

 String get mealType; int? get maxMinutes; List<String> get moodTags; List<String> get availableIngredientIds; List<String> get excludedIngredientIds; List<String> get unresolvedIngredients; String? get confidenceReason;
/// Create a copy of AiParsedRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiParsedRequestCopyWith<AiParsedRequest> get copyWith => _$AiParsedRequestCopyWithImpl<AiParsedRequest>(this as AiParsedRequest, _$identity);

  /// Serializes this AiParsedRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiParsedRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiParsedRequest&&(identical(other.mealType, _this.mealType) || other.mealType == _this.mealType)&&(identical(other.maxMinutes, _this.maxMinutes) || other.maxMinutes == _this.maxMinutes)&&const DeepCollectionEquality().equals(other.moodTags, _this.moodTags)&&const DeepCollectionEquality().equals(other.availableIngredientIds, _this.availableIngredientIds)&&const DeepCollectionEquality().equals(other.excludedIngredientIds, _this.excludedIngredientIds)&&const DeepCollectionEquality().equals(other.unresolvedIngredients, _this.unresolvedIngredients)&&(identical(other.confidenceReason, _this.confidenceReason) || other.confidenceReason == _this.confidenceReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiParsedRequest;
  return Object.hash(runtimeType,_this.mealType,_this.maxMinutes,const DeepCollectionEquality().hash(_this.moodTags),const DeepCollectionEquality().hash(_this.availableIngredientIds),const DeepCollectionEquality().hash(_this.excludedIngredientIds),const DeepCollectionEquality().hash(_this.unresolvedIngredients),_this.confidenceReason);
}

@override
String toString() {
  final _this = this as AiParsedRequest;
  return 'AiParsedRequest(mealType: ${_this.mealType}, maxMinutes: ${_this.maxMinutes}, moodTags: ${_this.moodTags}, availableIngredientIds: ${_this.availableIngredientIds}, excludedIngredientIds: ${_this.excludedIngredientIds}, unresolvedIngredients: ${_this.unresolvedIngredients}, confidenceReason: ${_this.confidenceReason})';
}


}

/// @nodoc
abstract mixin class $AiParsedRequestCopyWith<$Res>  {
  factory $AiParsedRequestCopyWith(AiParsedRequest value, $Res Function(AiParsedRequest) _then) = _$AiParsedRequestCopyWithImpl;
@useResult
$Res call({
 String mealType, int? maxMinutes, List<String> moodTags, List<String> availableIngredientIds, List<String> excludedIngredientIds, List<String> unresolvedIngredients, String? confidenceReason
});




}
/// @nodoc
class _$AiParsedRequestCopyWithImpl<$Res>
    implements $AiParsedRequestCopyWith<$Res> {
  _$AiParsedRequestCopyWithImpl(this._self, this._then);

  final AiParsedRequest _self;
  final $Res Function(AiParsedRequest) _then;

/// Create a copy of AiParsedRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mealType = null,Object? maxMinutes = freezed,Object? moodTags = null,Object? availableIngredientIds = null,Object? excludedIngredientIds = null,Object? unresolvedIngredients = null,Object? confidenceReason = freezed,}) {
  return _then(AiParsedRequest(
mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,maxMinutes: freezed == maxMinutes ? _self.maxMinutes : maxMinutes // ignore: cast_nullable_to_non_nullable
as int?,moodTags: null == moodTags ? _self.moodTags : moodTags // ignore: cast_nullable_to_non_nullable
as List<String>,availableIngredientIds: null == availableIngredientIds ? _self.availableIngredientIds : availableIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>,excludedIngredientIds: null == excludedIngredientIds ? _self.excludedIngredientIds : excludedIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>,unresolvedIngredients: null == unresolvedIngredients ? _self.unresolvedIngredients : unresolvedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,confidenceReason: freezed == confidenceReason ? _self.confidenceReason : confidenceReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiParsedRequest].
extension AiParsedRequestPatterns on AiParsedRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiParsedRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiParsedRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiParsedRequest value)  $default,){
final _that = this;
switch (_that) {
case _AiParsedRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiParsedRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AiParsedRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mealType,  int? maxMinutes,  List<String> moodTags,  List<String> availableIngredientIds,  List<String> excludedIngredientIds,  List<String> unresolvedIngredients,  String? confidenceReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiParsedRequest() when $default != null:
return $default(_that.mealType,_that.maxMinutes,_that.moodTags,_that.availableIngredientIds,_that.excludedIngredientIds,_that.unresolvedIngredients,_that.confidenceReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mealType,  int? maxMinutes,  List<String> moodTags,  List<String> availableIngredientIds,  List<String> excludedIngredientIds,  List<String> unresolvedIngredients,  String? confidenceReason)  $default,) {final _that = this;
switch (_that) {
case _AiParsedRequest():
return $default(_that.mealType,_that.maxMinutes,_that.moodTags,_that.availableIngredientIds,_that.excludedIngredientIds,_that.unresolvedIngredients,_that.confidenceReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mealType,  int? maxMinutes,  List<String> moodTags,  List<String> availableIngredientIds,  List<String> excludedIngredientIds,  List<String> unresolvedIngredients,  String? confidenceReason)?  $default,) {final _that = this;
switch (_that) {
case _AiParsedRequest() when $default != null:
return $default(_that.mealType,_that.maxMinutes,_that.moodTags,_that.availableIngredientIds,_that.excludedIngredientIds,_that.unresolvedIngredients,_that.confidenceReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiParsedRequest implements AiParsedRequest {
  const _AiParsedRequest({this.mealType = 'lunchbox', this.maxMinutes,  List<String> moodTags = const <String>[],  List<String> availableIngredientIds = const <String>[],  List<String> excludedIngredientIds = const <String>[],  List<String> unresolvedIngredients = const <String>[], this.confidenceReason}): _moodTags = moodTags,_availableIngredientIds = availableIngredientIds,_excludedIngredientIds = excludedIngredientIds,_unresolvedIngredients = unresolvedIngredients;
  factory _AiParsedRequest.fromJson(Map<String, dynamic> json) => _$AiParsedRequestFromJson(json);

@override@JsonKey() final  String mealType;
@override final  int? maxMinutes;
 final  List<String> _moodTags;
@override@JsonKey() List<String> get moodTags {
  if (_moodTags is EqualUnmodifiableListView) return _moodTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moodTags);
}

 final  List<String> _availableIngredientIds;
@override@JsonKey() List<String> get availableIngredientIds {
  if (_availableIngredientIds is EqualUnmodifiableListView) return _availableIngredientIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableIngredientIds);
}

 final  List<String> _excludedIngredientIds;
@override@JsonKey() List<String> get excludedIngredientIds {
  if (_excludedIngredientIds is EqualUnmodifiableListView) return _excludedIngredientIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedIngredientIds);
}

 final  List<String> _unresolvedIngredients;
@override@JsonKey() List<String> get unresolvedIngredients {
  if (_unresolvedIngredients is EqualUnmodifiableListView) return _unresolvedIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unresolvedIngredients);
}

@override final  String? confidenceReason;

/// Create a copy of AiParsedRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiParsedRequestCopyWith<_AiParsedRequest> get copyWith => __$AiParsedRequestCopyWithImpl<_AiParsedRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiParsedRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiParsedRequest&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.maxMinutes, maxMinutes) || other.maxMinutes == maxMinutes)&&const DeepCollectionEquality().equals(other.moodTags, _moodTags)&&const DeepCollectionEquality().equals(other.availableIngredientIds, _availableIngredientIds)&&const DeepCollectionEquality().equals(other.excludedIngredientIds, _excludedIngredientIds)&&const DeepCollectionEquality().equals(other.unresolvedIngredients, _unresolvedIngredients)&&(identical(other.confidenceReason, confidenceReason) || other.confidenceReason == confidenceReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mealType,maxMinutes,const DeepCollectionEquality().hash(_moodTags),const DeepCollectionEquality().hash(_availableIngredientIds),const DeepCollectionEquality().hash(_excludedIngredientIds),const DeepCollectionEquality().hash(_unresolvedIngredients),confidenceReason);
}

@override
String toString() {
    return 'AiParsedRequest(mealType: $mealType, maxMinutes: $maxMinutes, moodTags: $moodTags, availableIngredientIds: $availableIngredientIds, excludedIngredientIds: $excludedIngredientIds, unresolvedIngredients: $unresolvedIngredients, confidenceReason: $confidenceReason)';
}


}

/// @nodoc
abstract mixin class _$AiParsedRequestCopyWith<$Res> implements $AiParsedRequestCopyWith<$Res> {
  factory _$AiParsedRequestCopyWith(_AiParsedRequest value, $Res Function(_AiParsedRequest) _then) = __$AiParsedRequestCopyWithImpl;
@override @useResult
$Res call({
 String mealType, int? maxMinutes, List<String> moodTags, List<String> availableIngredientIds, List<String> excludedIngredientIds, List<String> unresolvedIngredients, String? confidenceReason
});




}
/// @nodoc
class __$AiParsedRequestCopyWithImpl<$Res>
    implements _$AiParsedRequestCopyWith<$Res> {
  __$AiParsedRequestCopyWithImpl(this._self, this._then);

  final _AiParsedRequest _self;
  final $Res Function(_AiParsedRequest) _then;

/// Create a copy of AiParsedRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mealType = null,Object? maxMinutes = freezed,Object? moodTags = null,Object? availableIngredientIds = null,Object? excludedIngredientIds = null,Object? unresolvedIngredients = null,Object? confidenceReason = freezed,}) {
  return _then(_AiParsedRequest(
mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,maxMinutes: freezed == maxMinutes ? _self.maxMinutes : maxMinutes // ignore: cast_nullable_to_non_nullable
as int?,moodTags: null == moodTags ? _self._moodTags : moodTags // ignore: cast_nullable_to_non_nullable
as List<String>,availableIngredientIds: null == availableIngredientIds ? _self._availableIngredientIds : availableIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>,excludedIngredientIds: null == excludedIngredientIds ? _self._excludedIngredientIds : excludedIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>,unresolvedIngredients: null == unresolvedIngredients ? _self._unresolvedIngredients : unresolvedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,confidenceReason: freezed == confidenceReason ? _self.confidenceReason : confidenceReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
