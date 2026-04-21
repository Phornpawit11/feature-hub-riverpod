import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_success_response.freezed.dart';
part 'auth_success_response.g.dart';

@freezed
abstract class AuthSuccessResponse with _$AuthSuccessResponse {
  const factory AuthSuccessResponse({
    required String accessToken,
    required String refreshToken,
    required AuthUser user,
  }) = _AuthSuccessResponse;

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessResponseFromJson(json);
}
