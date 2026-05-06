// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_pending_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterPendingResponse _$RegisterPendingResponseFromJson(
  Map<String, dynamic> json,
) => _RegisterPendingResponse(
  verificationId: json['verificationId'] as String,
  email: json['email'] as String,
  resendAvailableInSeconds: (json['resendAvailableInSeconds'] as num).toInt(),
);

Map<String, dynamic> _$RegisterPendingResponseToJson(
  _RegisterPendingResponse instance,
) => <String, dynamic>{
  'verificationId': instance.verificationId,
  'email': instance.email,
  'resendAvailableInSeconds': instance.resendAvailableInSeconds,
};
