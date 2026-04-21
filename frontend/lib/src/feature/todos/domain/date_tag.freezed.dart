// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateTag {

 String get id; String get name; String get colorValue;
/// Create a copy of DateTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateTagCopyWith<DateTag> get copyWith => _$DateTagCopyWithImpl<DateTag>(this as DateTag, _$identity);

  /// Serializes this DateTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateTag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,colorValue);

@override
String toString() {
  return 'DateTag(id: $id, name: $name, colorValue: $colorValue)';
}


}

/// @nodoc
abstract mixin class $DateTagCopyWith<$Res>  {
  factory $DateTagCopyWith(DateTag value, $Res Function(DateTag) _then) = _$DateTagCopyWithImpl;
@useResult
$Res call({
 String id, String name, String colorValue
});




}
/// @nodoc
class _$DateTagCopyWithImpl<$Res>
    implements $DateTagCopyWith<$Res> {
  _$DateTagCopyWithImpl(this._self, this._then);

  final DateTag _self;
  final $Res Function(DateTag) _then;

/// Create a copy of DateTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DateTag].
extension DateTagPatterns on DateTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateTag value)  $default,){
final _that = this;
switch (_that) {
case _DateTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateTag value)?  $default,){
final _that = this;
switch (_that) {
case _DateTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String colorValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateTag() when $default != null:
return $default(_that.id,_that.name,_that.colorValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String colorValue)  $default,) {final _that = this;
switch (_that) {
case _DateTag():
return $default(_that.id,_that.name,_that.colorValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String colorValue)?  $default,) {final _that = this;
switch (_that) {
case _DateTag() when $default != null:
return $default(_that.id,_that.name,_that.colorValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateTag implements DateTag {
   _DateTag({required this.id, required this.name, required this.colorValue});
  factory _DateTag.fromJson(Map<String, dynamic> json) => _$DateTagFromJson(json);

@override final  String id;
@override final  String name;
@override final  String colorValue;

/// Create a copy of DateTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateTagCopyWith<_DateTag> get copyWith => __$DateTagCopyWithImpl<_DateTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateTagToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateTag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,colorValue);

@override
String toString() {
  return 'DateTag(id: $id, name: $name, colorValue: $colorValue)';
}


}

/// @nodoc
abstract mixin class _$DateTagCopyWith<$Res> implements $DateTagCopyWith<$Res> {
  factory _$DateTagCopyWith(_DateTag value, $Res Function(_DateTag) _then) = __$DateTagCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String colorValue
});




}
/// @nodoc
class __$DateTagCopyWithImpl<$Res>
    implements _$DateTagCopyWith<$Res> {
  __$DateTagCopyWithImpl(this._self, this._then);

  final _DateTag _self;
  final $Res Function(_DateTag) _then;

/// Create a copy of DateTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorValue = null,}) {
  return _then(_DateTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
