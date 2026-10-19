// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_suggestion_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealSuggestionRequest {

 List<KidProfile> get selectedKids; List<String>? get availableIngredientIds; int? get maxMinutes; String get mealType; List<String> get moodTags; String? get freeTextNote;
/// Create a copy of MealSuggestionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealSuggestionRequestCopyWith<MealSuggestionRequest> get copyWith => _$MealSuggestionRequestCopyWithImpl<MealSuggestionRequest>(this as MealSuggestionRequest, _$identity);

  /// Serializes this MealSuggestionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MealSuggestionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealSuggestionRequest&&const DeepCollectionEquality().equals(other.selectedKids, _this.selectedKids)&&const DeepCollectionEquality().equals(other.availableIngredientIds, _this.availableIngredientIds)&&(identical(other.maxMinutes, _this.maxMinutes) || other.maxMinutes == _this.maxMinutes)&&(identical(other.mealType, _this.mealType) || other.mealType == _this.mealType)&&const DeepCollectionEquality().equals(other.moodTags, _this.moodTags)&&(identical(other.freeTextNote, _this.freeTextNote) || other.freeTextNote == _this.freeTextNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MealSuggestionRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.selectedKids),const DeepCollectionEquality().hash(_this.availableIngredientIds),_this.maxMinutes,_this.mealType,const DeepCollectionEquality().hash(_this.moodTags),_this.freeTextNote);
}

@override
String toString() {
  final _this = this as MealSuggestionRequest;
  return 'MealSuggestionRequest(selectedKids: ${_this.selectedKids}, availableIngredientIds: ${_this.availableIngredientIds}, maxMinutes: ${_this.maxMinutes}, mealType: ${_this.mealType}, moodTags: ${_this.moodTags}, freeTextNote: ${_this.freeTextNote})';
}


}

/// @nodoc
abstract mixin class $MealSuggestionRequestCopyWith<$Res>  {
  factory $MealSuggestionRequestCopyWith(MealSuggestionRequest value, $Res Function(MealSuggestionRequest) _then) = _$MealSuggestionRequestCopyWithImpl;
@useResult
$Res call({
 List<KidProfile> selectedKids, List<String>? availableIngredientIds, int? maxMinutes, String mealType, List<String> moodTags, String? freeTextNote
});




}
/// @nodoc
class _$MealSuggestionRequestCopyWithImpl<$Res>
    implements $MealSuggestionRequestCopyWith<$Res> {
  _$MealSuggestionRequestCopyWithImpl(this._self, this._then);

  final MealSuggestionRequest _self;
  final $Res Function(MealSuggestionRequest) _then;

/// Create a copy of MealSuggestionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedKids = null,Object? availableIngredientIds = freezed,Object? maxMinutes = freezed,Object? mealType = null,Object? moodTags = null,Object? freeTextNote = freezed,}) {
  return _then(MealSuggestionRequest(
selectedKids: null == selectedKids ? _self.selectedKids : selectedKids // ignore: cast_nullable_to_non_nullable
as List<KidProfile>,availableIngredientIds: freezed == availableIngredientIds ? _self.availableIngredientIds : availableIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>?,maxMinutes: freezed == maxMinutes ? _self.maxMinutes : maxMinutes // ignore: cast_nullable_to_non_nullable
as int?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,moodTags: null == moodTags ? _self.moodTags : moodTags // ignore: cast_nullable_to_non_nullable
as List<String>,freeTextNote: freezed == freeTextNote ? _self.freeTextNote : freeTextNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealSuggestionRequest].
extension MealSuggestionRequestPatterns on MealSuggestionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealSuggestionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealSuggestionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealSuggestionRequest value)  $default,){
final _that = this;
switch (_that) {
case _MealSuggestionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealSuggestionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MealSuggestionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KidProfile> selectedKids,  List<String>? availableIngredientIds,  int? maxMinutes,  String mealType,  List<String> moodTags,  String? freeTextNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealSuggestionRequest() when $default != null:
return $default(_that.selectedKids,_that.availableIngredientIds,_that.maxMinutes,_that.mealType,_that.moodTags,_that.freeTextNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KidProfile> selectedKids,  List<String>? availableIngredientIds,  int? maxMinutes,  String mealType,  List<String> moodTags,  String? freeTextNote)  $default,) {final _that = this;
switch (_that) {
case _MealSuggestionRequest():
return $default(_that.selectedKids,_that.availableIngredientIds,_that.maxMinutes,_that.mealType,_that.moodTags,_that.freeTextNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KidProfile> selectedKids,  List<String>? availableIngredientIds,  int? maxMinutes,  String mealType,  List<String> moodTags,  String? freeTextNote)?  $default,) {final _that = this;
switch (_that) {
case _MealSuggestionRequest() when $default != null:
return $default(_that.selectedKids,_that.availableIngredientIds,_that.maxMinutes,_that.mealType,_that.moodTags,_that.freeTextNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealSuggestionRequest implements MealSuggestionRequest {
  const _MealSuggestionRequest({required  List<KidProfile> selectedKids,  List<String>? availableIngredientIds, this.maxMinutes, this.mealType = 'lunchbox',  List<String> moodTags = const <String>[], this.freeTextNote}): _selectedKids = selectedKids,_availableIngredientIds = availableIngredientIds,_moodTags = moodTags;
  factory _MealSuggestionRequest.fromJson(Map<String, dynamic> json) => _$MealSuggestionRequestFromJson(json);

 final  List<KidProfile> _selectedKids;
@override List<KidProfile> get selectedKids {
  if (_selectedKids is EqualUnmodifiableListView) return _selectedKids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedKids);
}

 final  List<String>? _availableIngredientIds;
@override List<String>? get availableIngredientIds {
  final value = _availableIngredientIds;
  if (value == null) return null;
  if (_availableIngredientIds is EqualUnmodifiableListView) return _availableIngredientIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? maxMinutes;
@override@JsonKey() final  String mealType;
 final  List<String> _moodTags;
@override@JsonKey() List<String> get moodTags {
  if (_moodTags is EqualUnmodifiableListView) return _moodTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moodTags);
}

@override final  String? freeTextNote;

/// Create a copy of MealSuggestionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealSuggestionRequestCopyWith<_MealSuggestionRequest> get copyWith => __$MealSuggestionRequestCopyWithImpl<_MealSuggestionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealSuggestionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealSuggestionRequest&&const DeepCollectionEquality().equals(other.selectedKids, _selectedKids)&&const DeepCollectionEquality().equals(other.availableIngredientIds, _availableIngredientIds)&&(identical(other.maxMinutes, maxMinutes) || other.maxMinutes == maxMinutes)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&const DeepCollectionEquality().equals(other.moodTags, _moodTags)&&(identical(other.freeTextNote, freeTextNote) || other.freeTextNote == freeTextNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedKids),const DeepCollectionEquality().hash(_availableIngredientIds),maxMinutes,mealType,const DeepCollectionEquality().hash(_moodTags),freeTextNote);
}

@override
String toString() {
    return 'MealSuggestionRequest(selectedKids: $selectedKids, availableIngredientIds: $availableIngredientIds, maxMinutes: $maxMinutes, mealType: $mealType, moodTags: $moodTags, freeTextNote: $freeTextNote)';
}


}

/// @nodoc
abstract mixin class _$MealSuggestionRequestCopyWith<$Res> implements $MealSuggestionRequestCopyWith<$Res> {
  factory _$MealSuggestionRequestCopyWith(_MealSuggestionRequest value, $Res Function(_MealSuggestionRequest) _then) = __$MealSuggestionRequestCopyWithImpl;
@override @useResult
$Res call({
 List<KidProfile> selectedKids, List<String>? availableIngredientIds, int? maxMinutes, String mealType, List<String> moodTags, String? freeTextNote
});




}
/// @nodoc
class __$MealSuggestionRequestCopyWithImpl<$Res>
    implements _$MealSuggestionRequestCopyWith<$Res> {
  __$MealSuggestionRequestCopyWithImpl(this._self, this._then);

  final _MealSuggestionRequest _self;
  final $Res Function(_MealSuggestionRequest) _then;

/// Create a copy of MealSuggestionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedKids = null,Object? availableIngredientIds = freezed,Object? maxMinutes = freezed,Object? mealType = null,Object? moodTags = null,Object? freeTextNote = freezed,}) {
  return _then(_MealSuggestionRequest(
selectedKids: null == selectedKids ? _self._selectedKids : selectedKids // ignore: cast_nullable_to_non_nullable
as List<KidProfile>,availableIngredientIds: freezed == availableIngredientIds ? _self._availableIngredientIds : availableIngredientIds // ignore: cast_nullable_to_non_nullable
as List<String>?,maxMinutes: freezed == maxMinutes ? _self.maxMinutes : maxMinutes // ignore: cast_nullable_to_non_nullable
as int?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,moodTags: null == moodTags ? _self._moodTags : moodTags // ignore: cast_nullable_to_non_nullable
as List<String>,freeTextNote: freezed == freeTextNote ? _self.freeTextNote : freeTextNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
