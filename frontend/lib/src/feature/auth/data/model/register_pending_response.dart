import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_pending_response.freezed.dart';
part 'register_pending_response.g.dart';

@freezed
abstract class RegisterPendingResponse with _$RegisterPendingResponse {
  const factory RegisterPendingResponse({
    required String verificationId,
    required String email,
    required int resendAvailableInSeconds,
  }) = _RegisterPendingResponse;

  factory RegisterPendingResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterPendingResponseFromJson(json);
}
