import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_email_request.freezed.dart';
part 'check_email_request.g.dart';

@freezed
abstract class CheckEmailRequest with _$CheckEmailRequest {
  const factory CheckEmailRequest({required String email}) = _CheckEmailRequest;

  factory CheckEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailRequestFromJson(json);
}
