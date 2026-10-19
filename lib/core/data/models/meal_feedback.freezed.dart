// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealFeedback {

 String get id; String get recipeId; String? get kidId; String get reaction; String? get reasonTag; DateTime get date; String? get notes;
/// Create a copy of MealFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealFeedbackCopyWith<MealFeedback> get copyWith => _$MealFeedbackCopyWithImpl<MealFeedback>(this as MealFeedback, _$identity);

  /// Serializes this MealFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MealFeedback;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealFeedback&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.kidId, _this.kidId) || other.kidId == _this.kidId)&&(identical(other.reaction, _this.reaction) || other.reaction == _this.reaction)&&(identical(other.reasonTag, _this.reasonTag) || other.reasonTag == _this.reasonTag)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MealFeedback;
  return Object.hash(runtimeType,_this.id,_this.recipeId,_this.kidId,_this.reaction,_this.reasonTag,_this.date,_this.notes);
}

@override
String toString() {
  final _this = this as MealFeedback;
  return 'MealFeedback(id: ${_this.id}, recipeId: ${_this.recipeId}, kidId: ${_this.kidId}, reaction: ${_this.reaction}, reasonTag: ${_this.reasonTag}, date: ${_this.date}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $MealFeedbackCopyWith<$Res>  {
  factory $MealFeedbackCopyWith(MealFeedback value, $Res Function(MealFeedback) _then) = _$MealFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, String recipeId, String? kidId, String reaction, String? reasonTag, DateTime date, String? notes
});




}
/// @nodoc
class _$MealFeedbackCopyWithImpl<$Res>
    implements $MealFeedbackCopyWith<$Res> {
  _$MealFeedbackCopyWithImpl(this._self, this._then);

  final MealFeedback _self;
  final $Res Function(MealFeedback) _then;

/// Create a copy of MealFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeId = null,Object? kidId = freezed,Object? reaction = null,Object? reasonTag = freezed,Object? date = null,Object? notes = freezed,}) {
  return _then(MealFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,kidId: freezed == kidId ? _self.kidId : kidId // ignore: cast_nullable_to_non_nullable
as String?,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String,reasonTag: freezed == reasonTag ? _self.reasonTag : reasonTag // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealFeedback].
extension MealFeedbackPatterns on MealFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealFeedback value)  $default,){
final _that = this;
switch (_that) {
case _MealFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _MealFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipeId,  String? kidId,  String reaction,  String? reasonTag,  DateTime date,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealFeedback() when $default != null:
return $default(_that.id,_that.recipeId,_that.kidId,_that.reaction,_that.reasonTag,_that.date,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipeId,  String? kidId,  String reaction,  String? reasonTag,  DateTime date,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MealFeedback():
return $default(_that.id,_that.recipeId,_that.kidId,_that.reaction,_that.reasonTag,_that.date,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipeId,  String? kidId,  String reaction,  String? reasonTag,  DateTime date,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MealFeedback() when $default != null:
return $default(_that.id,_that.recipeId,_that.kidId,_that.reaction,_that.reasonTag,_that.date,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealFeedback implements MealFeedback {
  const _MealFeedback({required this.id, required this.recipeId, this.kidId, required this.reaction, this.reasonTag, required this.date, this.notes});
  factory _MealFeedback.fromJson(Map<String, dynamic> json) => _$MealFeedbackFromJson(json);

@override final  String id;
@override final  String recipeId;
@override final  String? kidId;
@override final  String reaction;
@override final  String? reasonTag;
@override final  DateTime date;
@override final  String? notes;

/// Create a copy of MealFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealFeedbackCopyWith<_MealFeedback> get copyWith => __$MealFeedbackCopyWithImpl<_MealFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.kidId, kidId) || other.kidId == kidId)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&(identical(other.reasonTag, reasonTag) || other.reasonTag == reasonTag)&&(identical(other.date, date) || other.date == date)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,recipeId,kidId,reaction,reasonTag,date,notes);
}

@override
String toString() {
    return 'MealFeedback(id: $id, recipeId: $recipeId, kidId: $kidId, reaction: $reaction, reasonTag: $reasonTag, date: $date, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MealFeedbackCopyWith<$Res> implements $MealFeedbackCopyWith<$Res> {
  factory _$MealFeedbackCopyWith(_MealFeedback value, $Res Function(_MealFeedback) _then) = __$MealFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipeId, String? kidId, String reaction, String? reasonTag, DateTime date, String? notes
});




}
/// @nodoc
class __$MealFeedbackCopyWithImpl<$Res>
    implements _$MealFeedbackCopyWith<$Res> {
  __$MealFeedbackCopyWithImpl(this._self, this._then);

  final _MealFeedback _self;
  final $Res Function(_MealFeedback) _then;

/// Create a copy of MealFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeId = null,Object? kidId = freezed,Object? reaction = null,Object? reasonTag = freezed,Object? date = null,Object? notes = freezed,}) {
  return _then(_MealFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,kidId: freezed == kidId ? _self.kidId : kidId // ignore: cast_nullable_to_non_nullable
as String?,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String,reasonTag: freezed == reasonTag ? _self.reasonTag : reasonTag // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
