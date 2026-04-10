// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tagged_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaggedDate {

 String get id; DateTime get date; String get tagId;
/// Create a copy of TaggedDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaggedDateCopyWith<TaggedDate> get copyWith => _$TaggedDateCopyWithImpl<TaggedDate>(this as TaggedDate, _$identity);

  /// Serializes this TaggedDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaggedDate&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.tagId, tagId) || other.tagId == tagId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,tagId);

@override
String toString() {
  return 'TaggedDate(id: $id, date: $date, tagId: $tagId)';
}


}

/// @nodoc
abstract mixin class $TaggedDateCopyWith<$Res>  {
  factory $TaggedDateCopyWith(TaggedDate value, $Res Function(TaggedDate) _then) = _$TaggedDateCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String tagId
});




}
/// @nodoc
class _$TaggedDateCopyWithImpl<$Res>
    implements $TaggedDateCopyWith<$Res> {
  _$TaggedDateCopyWithImpl(this._self, this._then);

  final TaggedDate _self;
  final $Res Function(TaggedDate) _then;

/// Create a copy of TaggedDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? tagId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaggedDate].
extension TaggedDatePatterns on TaggedDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaggedDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaggedDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaggedDate value)  $default,){
final _that = this;
switch (_that) {
case _TaggedDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaggedDate value)?  $default,){
final _that = this;
switch (_that) {
case _TaggedDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String tagId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaggedDate() when $default != null:
return $default(_that.id,_that.date,_that.tagId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String tagId)  $default,) {final _that = this;
switch (_that) {
case _TaggedDate():
return $default(_that.id,_that.date,_that.tagId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String tagId)?  $default,) {final _that = this;
switch (_that) {
case _TaggedDate() when $default != null:
return $default(_that.id,_that.date,_that.tagId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaggedDate implements TaggedDate {
   _TaggedDate({required this.id, required this.date, required this.tagId});
  factory _TaggedDate.fromJson(Map<String, dynamic> json) => _$TaggedDateFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String tagId;

/// Create a copy of TaggedDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaggedDateCopyWith<_TaggedDate> get copyWith => __$TaggedDateCopyWithImpl<_TaggedDate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaggedDateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaggedDate&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.tagId, tagId) || other.tagId == tagId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,tagId);

@override
String toString() {
  return 'TaggedDate(id: $id, date: $date, tagId: $tagId)';
}


}

/// @nodoc
abstract mixin class _$TaggedDateCopyWith<$Res> implements $TaggedDateCopyWith<$Res> {
  factory _$TaggedDateCopyWith(_TaggedDate value, $Res Function(_TaggedDate) _then) = __$TaggedDateCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String tagId
});




}
/// @nodoc
class __$TaggedDateCopyWithImpl<$Res>
    implements _$TaggedDateCopyWith<$Res> {
  __$TaggedDateCopyWithImpl(this._self, this._then);

  final _TaggedDate _self;
  final $Res Function(_TaggedDate) _then;

/// Create a copy of TaggedDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? tagId = null,}) {
  return _then(_TaggedDate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
