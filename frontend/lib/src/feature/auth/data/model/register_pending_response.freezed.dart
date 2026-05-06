// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_pending_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterPendingResponse {

 String get verificationId; String get email; int get resendAvailableInSeconds;
/// Create a copy of RegisterPendingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPendingResponseCopyWith<RegisterPendingResponse> get copyWith => _$RegisterPendingResponseCopyWithImpl<RegisterPendingResponse>(this as RegisterPendingResponse, _$identity);

  /// Serializes this RegisterPendingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPendingResponse&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.resendAvailableInSeconds, resendAvailableInSeconds) || other.resendAvailableInSeconds == resendAvailableInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verificationId,email,resendAvailableInSeconds);

@override
String toString() {
  return 'RegisterPendingResponse(verificationId: $verificationId, email: $email, resendAvailableInSeconds: $resendAvailableInSeconds)';
}


}

/// @nodoc
abstract mixin class $RegisterPendingResponseCopyWith<$Res>  {
  factory $RegisterPendingResponseCopyWith(RegisterPendingResponse value, $Res Function(RegisterPendingResponse) _then) = _$RegisterPendingResponseCopyWithImpl;
@useResult
$Res call({
 String verificationId, String email, int resendAvailableInSeconds
});




}
/// @nodoc
class _$RegisterPendingResponseCopyWithImpl<$Res>
    implements $RegisterPendingResponseCopyWith<$Res> {
  _$RegisterPendingResponseCopyWithImpl(this._self, this._then);

  final RegisterPendingResponse _self;
  final $Res Function(RegisterPendingResponse) _then;

/// Create a copy of RegisterPendingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verificationId = null,Object? email = null,Object? resendAvailableInSeconds = null,}) {
  return _then(_self.copyWith(
verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,resendAvailableInSeconds: null == resendAvailableInSeconds ? _self.resendAvailableInSeconds : resendAvailableInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterPendingResponse].
extension RegisterPendingResponsePatterns on RegisterPendingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterPendingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterPendingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterPendingResponse value)  $default,){
final _that = this;
switch (_that) {
case _RegisterPendingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterPendingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterPendingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String verificationId,  String email,  int resendAvailableInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterPendingResponse() when $default != null:
return $default(_that.verificationId,_that.email,_that.resendAvailableInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String verificationId,  String email,  int resendAvailableInSeconds)  $default,) {final _that = this;
switch (_that) {
case _RegisterPendingResponse():
return $default(_that.verificationId,_that.email,_that.resendAvailableInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String verificationId,  String email,  int resendAvailableInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RegisterPendingResponse() when $default != null:
return $default(_that.verificationId,_that.email,_that.resendAvailableInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterPendingResponse implements RegisterPendingResponse {
  const _RegisterPendingResponse({required this.verificationId, required this.email, required this.resendAvailableInSeconds});
  factory _RegisterPendingResponse.fromJson(Map<String, dynamic> json) => _$RegisterPendingResponseFromJson(json);

@override final  String verificationId;
@override final  String email;
@override final  int resendAvailableInSeconds;

/// Create a copy of RegisterPendingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterPendingResponseCopyWith<_RegisterPendingResponse> get copyWith => __$RegisterPendingResponseCopyWithImpl<_RegisterPendingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterPendingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterPendingResponse&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.resendAvailableInSeconds, resendAvailableInSeconds) || other.resendAvailableInSeconds == resendAvailableInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verificationId,email,resendAvailableInSeconds);

@override
String toString() {
  return 'RegisterPendingResponse(verificationId: $verificationId, email: $email, resendAvailableInSeconds: $resendAvailableInSeconds)';
}


}

/// @nodoc
abstract mixin class _$RegisterPendingResponseCopyWith<$Res> implements $RegisterPendingResponseCopyWith<$Res> {
  factory _$RegisterPendingResponseCopyWith(_RegisterPendingResponse value, $Res Function(_RegisterPendingResponse) _then) = __$RegisterPendingResponseCopyWithImpl;
@override @useResult
$Res call({
 String verificationId, String email, int resendAvailableInSeconds
});




}
/// @nodoc
class __$RegisterPendingResponseCopyWithImpl<$Res>
    implements _$RegisterPendingResponseCopyWith<$Res> {
  __$RegisterPendingResponseCopyWithImpl(this._self, this._then);

  final _RegisterPendingResponse _self;
  final $Res Function(_RegisterPendingResponse) _then;

/// Create a copy of RegisterPendingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verificationId = null,Object? email = null,Object? resendAvailableInSeconds = null,}) {
  return _then(_RegisterPendingResponse(
verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,resendAvailableInSeconds: null == resendAvailableInSeconds ? _self.resendAvailableInSeconds : resendAvailableInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
