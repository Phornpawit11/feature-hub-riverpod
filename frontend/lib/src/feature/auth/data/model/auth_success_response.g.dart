// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSuccessResponse _$AuthSuccessResponseFromJson(Map<String, dynamic> json) =>
    _AuthSuccessResponse(
      accessToken: json['accessToken'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthSuccessResponseToJson(
  _AuthSuccessResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'user': instance.user,
};
