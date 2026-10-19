// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kid_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KidProfile {

 String get id; String get name; DateTime get birthDate; List<String> get allergies; List<String> get dislikes; List<String> get likes; int get pickyLevel; String get lunchboxType; String? get notes;
/// Create a copy of KidProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KidProfileCopyWith<KidProfile> get copyWith => _$KidProfileCopyWithImpl<KidProfile>(this as KidProfile, _$identity);

  /// Serializes this KidProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KidProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&const DeepCollectionEquality().equals(other.allergies, _this.allergies)&&const DeepCollectionEquality().equals(other.dislikes, _this.dislikes)&&const DeepCollectionEquality().equals(other.likes, _this.likes)&&(identical(other.pickyLevel, _this.pickyLevel) || other.pickyLevel == _this.pickyLevel)&&(identical(other.lunchboxType, _this.lunchboxType) || other.lunchboxType == _this.lunchboxType)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KidProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.birthDate,const DeepCollectionEquality().hash(_this.allergies),const DeepCollectionEquality().hash(_this.dislikes),const DeepCollectionEquality().hash(_this.likes),_this.pickyLevel,_this.lunchboxType,_this.notes);
}

@override
String toString() {
  final _this = this as KidProfile;
  return 'KidProfile(id: ${_this.id}, name: ${_this.name}, birthDate: ${_this.birthDate}, allergies: ${_this.allergies}, dislikes: ${_this.dislikes}, likes: ${_this.likes}, pickyLevel: ${_this.pickyLevel}, lunchboxType: ${_this.lunchboxType}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $KidProfileCopyWith<$Res>  {
  factory $KidProfileCopyWith(KidProfile value, $Res Function(KidProfile) _then) = _$KidProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime birthDate, List<String> allergies, List<String> dislikes, List<String> likes, int pickyLevel, String lunchboxType, String? notes
});




}
/// @nodoc
class _$KidProfileCopyWithImpl<$Res>
    implements $KidProfileCopyWith<$Res> {
  _$KidProfileCopyWithImpl(this._self, this._then);

  final KidProfile _self;
  final $Res Function(KidProfile) _then;

/// Create a copy of KidProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? birthDate = null,Object? allergies = null,Object? dislikes = null,Object? likes = null,Object? pickyLevel = null,Object? lunchboxType = null,Object? notes = freezed,}) {
  return _then(KidProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dislikes: null == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as List<String>,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>,pickyLevel: null == pickyLevel ? _self.pickyLevel : pickyLevel // ignore: cast_nullable_to_non_nullable
as int,lunchboxType: null == lunchboxType ? _self.lunchboxType : lunchboxType // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KidProfile].
extension KidProfilePatterns on KidProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KidProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KidProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KidProfile value)  $default,){
final _that = this;
switch (_that) {
case _KidProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KidProfile value)?  $default,){
final _that = this;
switch (_that) {
case _KidProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime birthDate,  List<String> allergies,  List<String> dislikes,  List<String> likes,  int pickyLevel,  String lunchboxType,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KidProfile() when $default != null:
return $default(_that.id,_that.name,_that.birthDate,_that.allergies,_that.dislikes,_that.likes,_that.pickyLevel,_that.lunchboxType,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime birthDate,  List<String> allergies,  List<String> dislikes,  List<String> likes,  int pickyLevel,  String lunchboxType,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _KidProfile():
return $default(_that.id,_that.name,_that.birthDate,_that.allergies,_that.dislikes,_that.likes,_that.pickyLevel,_that.lunchboxType,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime birthDate,  List<String> allergies,  List<String> dislikes,  List<String> likes,  int pickyLevel,  String lunchboxType,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _KidProfile() when $default != null:
return $default(_that.id,_that.name,_that.birthDate,_that.allergies,_that.dislikes,_that.likes,_that.pickyLevel,_that.lunchboxType,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KidProfile implements KidProfile {
  const _KidProfile({required this.id, required this.name, required this.birthDate,  List<String> allergies = const <String>[],  List<String> dislikes = const <String>[],  List<String> likes = const <String>[], this.pickyLevel = 0, this.lunchboxType = 'none', this.notes}): _allergies = allergies,_dislikes = dislikes,_likes = likes;
  factory _KidProfile.fromJson(Map<String, dynamic> json) => _$KidProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime birthDate;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _dislikes;
@override@JsonKey() List<String> get dislikes {
  if (_dislikes is EqualUnmodifiableListView) return _dislikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dislikes);
}

 final  List<String> _likes;
@override@JsonKey() List<String> get likes {
  if (_likes is EqualUnmodifiableListView) return _likes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likes);
}

@override@JsonKey() final  int pickyLevel;
@override@JsonKey() final  String lunchboxType;
@override final  String? notes;

/// Create a copy of KidProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KidProfileCopyWith<_KidProfile> get copyWith => __$KidProfileCopyWithImpl<_KidProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KidProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KidProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other.allergies, _allergies)&&const DeepCollectionEquality().equals(other.dislikes, _dislikes)&&const DeepCollectionEquality().equals(other.likes, _likes)&&(identical(other.pickyLevel, pickyLevel) || other.pickyLevel == pickyLevel)&&(identical(other.lunchboxType, lunchboxType) || other.lunchboxType == lunchboxType)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,birthDate,const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_dislikes),const DeepCollectionEquality().hash(_likes),pickyLevel,lunchboxType,notes);
}

@override
String toString() {
    return 'KidProfile(id: $id, name: $name, birthDate: $birthDate, allergies: $allergies, dislikes: $dislikes, likes: $likes, pickyLevel: $pickyLevel, lunchboxType: $lunchboxType, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$KidProfileCopyWith<$Res> implements $KidProfileCopyWith<$Res> {
  factory _$KidProfileCopyWith(_KidProfile value, $Res Function(_KidProfile) _then) = __$KidProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime birthDate, List<String> allergies, List<String> dislikes, List<String> likes, int pickyLevel, String lunchboxType, String? notes
});




}
/// @nodoc
class __$KidProfileCopyWithImpl<$Res>
    implements _$KidProfileCopyWith<$Res> {
  __$KidProfileCopyWithImpl(this._self, this._then);

  final _KidProfile _self;
  final $Res Function(_KidProfile) _then;

/// Create a copy of KidProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? birthDate = null,Object? allergies = null,Object? dislikes = null,Object? likes = null,Object? pickyLevel = null,Object? lunchboxType = null,Object? notes = freezed,}) {
  return _then(_KidProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dislikes: null == dislikes ? _self._dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as List<String>,likes: null == likes ? _self._likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>,pickyLevel: null == pickyLevel ? _self.pickyLevel : pickyLevel // ignore: cast_nullable_to_non_nullable
as int,lunchboxType: null == lunchboxType ? _self.lunchboxType : lunchboxType // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
