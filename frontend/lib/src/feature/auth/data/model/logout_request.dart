import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_request.freezed.dart';
part 'logout_request.g.dart';

@freezed
abstract class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({required String refreshToken}) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}
