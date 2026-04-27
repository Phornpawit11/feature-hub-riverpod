import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_email_response.freezed.dart';
part 'check_email_response.g.dart';

@freezed
abstract class CheckEmailResponse with _$CheckEmailResponse {
  const factory CheckEmailResponse({required bool available}) =
      _CheckEmailResponse;

  factory CheckEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailResponseFromJson(json);
}
