// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthErrorResponse _$AuthErrorResponseFromJson(Map<String, dynamic> json) =>
    _AuthErrorResponse(
      messageList:
          (json['messageList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AuthErrorResponseToJson(_AuthErrorResponse instance) =>
    <String, dynamic>{
      'messageList': instance.messageList,
      'message': instance.message,
    };
