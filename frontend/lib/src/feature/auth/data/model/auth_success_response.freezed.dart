// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_success_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSuccessResponse {

 String get accessToken; AuthUser get user;
/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSuccessResponseCopyWith<AuthSuccessResponse> get copyWith => _$AuthSuccessResponseCopyWithImpl<AuthSuccessResponse>(this as AuthSuccessResponse, _$identity);

  /// Serializes this AuthSuccessResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSuccessResponse&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,user);

@override
String toString() {
  return 'AuthSuccessResponse(accessToken: $accessToken, user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthSuccessResponseCopyWith<$Res>  {
  factory $AuthSuccessResponseCopyWith(AuthSuccessResponse value, $Res Function(AuthSuccessResponse) _then) = _$AuthSuccessResponseCopyWithImpl;
@useResult
$Res call({
 String accessToken, AuthUser user
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthSuccessResponseCopyWithImpl<$Res>
    implements $AuthSuccessResponseCopyWith<$Res> {
  _$AuthSuccessResponseCopyWithImpl(this._self, this._then);

  final AuthSuccessResponse _self;
  final $Res Function(AuthSuccessResponse) _then;

/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? user = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}
/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthSuccessResponse].
extension AuthSuccessResponsePatterns on AuthSuccessResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSuccessResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSuccessResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSuccessResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuthSuccessResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSuccessResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSuccessResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  AuthUser user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSuccessResponse() when $default != null:
return $default(_that.accessToken,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  AuthUser user)  $default,) {final _that = this;
switch (_that) {
case _AuthSuccessResponse():
return $default(_that.accessToken,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  AuthUser user)?  $default,) {final _that = this;
switch (_that) {
case _AuthSuccessResponse() when $default != null:
return $default(_that.accessToken,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSuccessResponse implements AuthSuccessResponse {
  const _AuthSuccessResponse({required this.accessToken, required this.user});
  factory _AuthSuccessResponse.fromJson(Map<String, dynamic> json) => _$AuthSuccessResponseFromJson(json);

@override final  String accessToken;
@override final  AuthUser user;

/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSuccessResponseCopyWith<_AuthSuccessResponse> get copyWith => __$AuthSuccessResponseCopyWithImpl<_AuthSuccessResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSuccessResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSuccessResponse&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,user);

@override
String toString() {
  return 'AuthSuccessResponse(accessToken: $accessToken, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthSuccessResponseCopyWith<$Res> implements $AuthSuccessResponseCopyWith<$Res> {
  factory _$AuthSuccessResponseCopyWith(_AuthSuccessResponse value, $Res Function(_AuthSuccessResponse) _then) = __$AuthSuccessResponseCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, AuthUser user
});


@override $AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthSuccessResponseCopyWithImpl<$Res>
    implements _$AuthSuccessResponseCopyWith<$Res> {
  __$AuthSuccessResponseCopyWithImpl(this._self, this._then);

  final _AuthSuccessResponse _self;
  final $Res Function(_AuthSuccessResponse) _then;

/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? user = null,}) {
  return _then(_AuthSuccessResponse(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}

/// Create a copy of AuthSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
