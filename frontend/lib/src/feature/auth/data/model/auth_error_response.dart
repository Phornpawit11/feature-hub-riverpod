import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_error_response.freezed.dart';
part 'auth_error_response.g.dart';

@freezed
abstract class AuthErrorResponse with _$AuthErrorResponse {
  const factory AuthErrorResponse({
    @Default(<String>[]) List<String> messageList,
    String? message,
  }) = _AuthErrorResponse;

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorResponseFromJson(_normalizeAuthErrorJson(json));
}

Map<String, dynamic> _normalizeAuthErrorJson(Map<String, dynamic> json) {
  final rawMessage = json['message'];

  return <String, dynamic>{
    'message': rawMessage is String ? rawMessage : null,
    'messageList': rawMessage is List
        ? rawMessage.whereType<String>().toList()
        : const <String>[],
  };
}
