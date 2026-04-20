// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_error_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthErrorResponse {

 List<String> get messageList; String? get message;
/// Create a copy of AuthErrorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorResponseCopyWith<AuthErrorResponse> get copyWith => _$AuthErrorResponseCopyWithImpl<AuthErrorResponse>(this as AuthErrorResponse, _$identity);

  /// Serializes this AuthErrorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthErrorResponse&&const DeepCollectionEquality().equals(other.messageList, messageList)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messageList),message);

@override
String toString() {
  return 'AuthErrorResponse(messageList: $messageList, message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthErrorResponseCopyWith<$Res>  {
  factory $AuthErrorResponseCopyWith(AuthErrorResponse value, $Res Function(AuthErrorResponse) _then) = _$AuthErrorResponseCopyWithImpl;
@useResult
$Res call({
 List<String> messageList, String? message
});




}
/// @nodoc
class _$AuthErrorResponseCopyWithImpl<$Res>
    implements $AuthErrorResponseCopyWith<$Res> {
  _$AuthErrorResponseCopyWithImpl(this._self, this._then);

  final AuthErrorResponse _self;
  final $Res Function(AuthErrorResponse) _then;

/// Create a copy of AuthErrorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageList = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
messageList: null == messageList ? _self.messageList : messageList // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthErrorResponse].
extension AuthErrorResponsePatterns on AuthErrorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthErrorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthErrorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthErrorResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuthErrorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthErrorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuthErrorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> messageList,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthErrorResponse() when $default != null:
return $default(_that.messageList,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> messageList,  String? message)  $default,) {final _that = this;
switch (_that) {
case _AuthErrorResponse():
return $default(_that.messageList,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> messageList,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _AuthErrorResponse() when $default != null:
return $default(_that.messageList,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthErrorResponse implements AuthErrorResponse {
  const _AuthErrorResponse({final  List<String> messageList = const <String>[], this.message}): _messageList = messageList;
  factory _AuthErrorResponse.fromJson(Map<String, dynamic> json) => _$AuthErrorResponseFromJson(json);

 final  List<String> _messageList;
@override@JsonKey() List<String> get messageList {
  if (_messageList is EqualUnmodifiableListView) return _messageList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageList);
}

@override final  String? message;

/// Create a copy of AuthErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorResponseCopyWith<_AuthErrorResponse> get copyWith => __$AuthErrorResponseCopyWithImpl<_AuthErrorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthErrorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthErrorResponse&&const DeepCollectionEquality().equals(other._messageList, _messageList)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messageList),message);

@override
String toString() {
  return 'AuthErrorResponse(messageList: $messageList, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorResponseCopyWith<$Res> implements $AuthErrorResponseCopyWith<$Res> {
  factory _$AuthErrorResponseCopyWith(_AuthErrorResponse value, $Res Function(_AuthErrorResponse) _then) = __$AuthErrorResponseCopyWithImpl;
@override @useResult
$Res call({
 List<String> messageList, String? message
});




}
/// @nodoc
class __$AuthErrorResponseCopyWithImpl<$Res>
    implements _$AuthErrorResponseCopyWith<$Res> {
  __$AuthErrorResponseCopyWithImpl(this._self, this._then);

  final _AuthErrorResponse _self;
  final $Res Function(_AuthErrorResponse) _then;

/// Create a copy of AuthErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageList = null,Object? message = freezed,}) {
  return _then(_AuthErrorResponse(
messageList: null == messageList ? _self._messageList : messageList // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
