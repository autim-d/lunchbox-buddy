// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_ranking_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiRankedItem {

 String get recipeId; String get reasonAr; String? get substitutionTip;
/// Create a copy of AiRankedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiRankedItemCopyWith<AiRankedItem> get copyWith => _$AiRankedItemCopyWithImpl<AiRankedItem>(this as AiRankedItem, _$identity);

  /// Serializes this AiRankedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiRankedItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiRankedItem&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.reasonAr, _this.reasonAr) || other.reasonAr == _this.reasonAr)&&(identical(other.substitutionTip, _this.substitutionTip) || other.substitutionTip == _this.substitutionTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiRankedItem;
  return Object.hash(runtimeType,_this.recipeId,_this.reasonAr,_this.substitutionTip);
}

@override
String toString() {
  final _this = this as AiRankedItem;
  return 'AiRankedItem(recipeId: ${_this.recipeId}, reasonAr: ${_this.reasonAr}, substitutionTip: ${_this.substitutionTip})';
}


}

/// @nodoc
abstract mixin class $AiRankedItemCopyWith<$Res>  {
  factory $AiRankedItemCopyWith(AiRankedItem value, $Res Function(AiRankedItem) _then) = _$AiRankedItemCopyWithImpl;
@useResult
$Res call({
 String recipeId, String reasonAr, String? substitutionTip
});




}
/// @nodoc
class _$AiRankedItemCopyWithImpl<$Res>
    implements $AiRankedItemCopyWith<$Res> {
  _$AiRankedItemCopyWithImpl(this._self, this._then);

  final AiRankedItem _self;
  final $Res Function(AiRankedItem) _then;

/// Create a copy of AiRankedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipeId = null,Object? reasonAr = null,Object? substitutionTip = freezed,}) {
  return _then(AiRankedItem(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,reasonAr: null == reasonAr ? _self.reasonAr : reasonAr // ignore: cast_nullable_to_non_nullable
as String,substitutionTip: freezed == substitutionTip ? _self.substitutionTip : substitutionTip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiRankedItem].
extension AiRankedItemPatterns on AiRankedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiRankedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiRankedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiRankedItem value)  $default,){
final _that = this;
switch (_that) {
case _AiRankedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiRankedItem value)?  $default,){
final _that = this;
switch (_that) {
case _AiRankedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recipeId,  String reasonAr,  String? substitutionTip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiRankedItem() when $default != null:
return $default(_that.recipeId,_that.reasonAr,_that.substitutionTip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recipeId,  String reasonAr,  String? substitutionTip)  $default,) {final _that = this;
switch (_that) {
case _AiRankedItem():
return $default(_that.recipeId,_that.reasonAr,_that.substitutionTip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recipeId,  String reasonAr,  String? substitutionTip)?  $default,) {final _that = this;
switch (_that) {
case _AiRankedItem() when $default != null:
return $default(_that.recipeId,_that.reasonAr,_that.substitutionTip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiRankedItem implements AiRankedItem {
  const _AiRankedItem({required this.recipeId, required this.reasonAr, this.substitutionTip});
  factory _AiRankedItem.fromJson(Map<String, dynamic> json) => _$AiRankedItemFromJson(json);

@override final  String recipeId;
@override final  String reasonAr;
@override final  String? substitutionTip;

/// Create a copy of AiRankedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiRankedItemCopyWith<_AiRankedItem> get copyWith => __$AiRankedItemCopyWithImpl<_AiRankedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiRankedItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiRankedItem&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.reasonAr, reasonAr) || other.reasonAr == reasonAr)&&(identical(other.substitutionTip, substitutionTip) || other.substitutionTip == substitutionTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recipeId,reasonAr,substitutionTip);
}

@override
String toString() {
    return 'AiRankedItem(recipeId: $recipeId, reasonAr: $reasonAr, substitutionTip: $substitutionTip)';
}


}

/// @nodoc
abstract mixin class _$AiRankedItemCopyWith<$Res> implements $AiRankedItemCopyWith<$Res> {
  factory _$AiRankedItemCopyWith(_AiRankedItem value, $Res Function(_AiRankedItem) _then) = __$AiRankedItemCopyWithImpl;
@override @useResult
$Res call({
 String recipeId, String reasonAr, String? substitutionTip
});




}
/// @nodoc
class __$AiRankedItemCopyWithImpl<$Res>
    implements _$AiRankedItemCopyWith<$Res> {
  __$AiRankedItemCopyWithImpl(this._self, this._then);

  final _AiRankedItem _self;
  final $Res Function(_AiRankedItem) _then;

/// Create a copy of AiRankedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipeId = null,Object? reasonAr = null,Object? substitutionTip = freezed,}) {
  return _then(_AiRankedItem(
recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,reasonAr: null == reasonAr ? _self.reasonAr : reasonAr // ignore: cast_nullable_to_non_nullable
as String,substitutionTip: freezed == substitutionTip ? _self.substitutionTip : substitutionTip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiRankingResponse {

 List<AiRankedItem> get items;
/// Create a copy of AiRankingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiRankingResponseCopyWith<AiRankingResponse> get copyWith => _$AiRankingResponseCopyWithImpl<AiRankingResponse>(this as AiRankingResponse, _$identity);

  /// Serializes this AiRankingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiRankingResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiRankingResponse&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiRankingResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as AiRankingResponse;
  return 'AiRankingResponse(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $AiRankingResponseCopyWith<$Res>  {
  factory $AiRankingResponseCopyWith(AiRankingResponse value, $Res Function(AiRankingResponse) _then) = _$AiRankingResponseCopyWithImpl;
@useResult
$Res call({
 List<AiRankedItem> items
});




}
/// @nodoc
class _$AiRankingResponseCopyWithImpl<$Res>
    implements $AiRankingResponseCopyWith<$Res> {
  _$AiRankingResponseCopyWithImpl(this._self, this._then);

  final AiRankingResponse _self;
  final $Res Function(AiRankingResponse) _then;

/// Create a copy of AiRankingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(AiRankingResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AiRankedItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiRankingResponse].
extension AiRankingResponsePatterns on AiRankingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiRankingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiRankingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiRankingResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiRankingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiRankingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiRankingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiRankedItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiRankingResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiRankedItem> items)  $default,) {final _that = this;
switch (_that) {
case _AiRankingResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiRankedItem> items)?  $default,) {final _that = this;
switch (_that) {
case _AiRankingResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiRankingResponse implements AiRankingResponse {
  const _AiRankingResponse({ List<AiRankedItem> items = const <AiRankedItem>[]}): _items = items;
  factory _AiRankingResponse.fromJson(Map<String, dynamic> json) => _$AiRankingResponseFromJson(json);

 final  List<AiRankedItem> _items;
@override@JsonKey() List<AiRankedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of AiRankingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiRankingResponseCopyWith<_AiRankingResponse> get copyWith => __$AiRankingResponseCopyWithImpl<_AiRankingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiRankingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiRankingResponse&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'AiRankingResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$AiRankingResponseCopyWith<$Res> implements $AiRankingResponseCopyWith<$Res> {
  factory _$AiRankingResponseCopyWith(_AiRankingResponse value, $Res Function(_AiRankingResponse) _then) = __$AiRankingResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AiRankedItem> items
});




}
/// @nodoc
class __$AiRankingResponseCopyWithImpl<$Res>
    implements _$AiRankingResponseCopyWith<$Res> {
  __$AiRankingResponseCopyWithImpl(this._self, this._then);

  final _AiRankingResponse _self;
  final $Res Function(_AiRankingResponse) _then;

/// Create a copy of AiRankingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_AiRankingResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AiRankedItem>,
  ));
}


}

// dart format on
