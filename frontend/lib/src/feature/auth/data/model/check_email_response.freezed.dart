// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_email_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckEmailResponse {

 bool get available;
/// Create a copy of CheckEmailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckEmailResponseCopyWith<CheckEmailResponse> get copyWith => _$CheckEmailResponseCopyWithImpl<CheckEmailResponse>(this as CheckEmailResponse, _$identity);

  /// Serializes this CheckEmailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailResponse&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available);

@override
String toString() {
  return 'CheckEmailResponse(available: $available)';
}


}

/// @nodoc
abstract mixin class $CheckEmailResponseCopyWith<$Res>  {
  factory $CheckEmailResponseCopyWith(CheckEmailResponse value, $Res Function(CheckEmailResponse) _then) = _$CheckEmailResponseCopyWithImpl;
@useResult
$Res call({
 bool available
});




}
/// @nodoc
class _$CheckEmailResponseCopyWithImpl<$Res>
    implements $CheckEmailResponseCopyWith<$Res> {
  _$CheckEmailResponseCopyWithImpl(this._self, this._then);

  final CheckEmailResponse _self;
  final $Res Function(CheckEmailResponse) _then;

/// Create a copy of CheckEmailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckEmailResponse].
extension CheckEmailResponsePatterns on CheckEmailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckEmailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckEmailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckEmailResponse value)  $default,){
final _that = this;
switch (_that) {
case _CheckEmailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckEmailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CheckEmailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckEmailResponse() when $default != null:
return $default(_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available)  $default,) {final _that = this;
switch (_that) {
case _CheckEmailResponse():
return $default(_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available)?  $default,) {final _that = this;
switch (_that) {
case _CheckEmailResponse() when $default != null:
return $default(_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckEmailResponse implements CheckEmailResponse {
  const _CheckEmailResponse({required this.available});
  factory _CheckEmailResponse.fromJson(Map<String, dynamic> json) => _$CheckEmailResponseFromJson(json);

@override final  bool available;

/// Create a copy of CheckEmailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckEmailResponseCopyWith<_CheckEmailResponse> get copyWith => __$CheckEmailResponseCopyWithImpl<_CheckEmailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckEmailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckEmailResponse&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available);

@override
String toString() {
  return 'CheckEmailResponse(available: $available)';
}


}

/// @nodoc
abstract mixin class _$CheckEmailResponseCopyWith<$Res> implements $CheckEmailResponseCopyWith<$Res> {
  factory _$CheckEmailResponseCopyWith(_CheckEmailResponse value, $Res Function(_CheckEmailResponse) _then) = __$CheckEmailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool available
});




}
/// @nodoc
class __$CheckEmailResponseCopyWithImpl<$Res>
    implements _$CheckEmailResponseCopyWith<$Res> {
  __$CheckEmailResponseCopyWithImpl(this._self, this._then);

  final _CheckEmailResponse _self;
  final $Res Function(_CheckEmailResponse) _then;

/// Create a copy of CheckEmailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,}) {
  return _then(_CheckEmailResponse(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
