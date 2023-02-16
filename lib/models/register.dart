import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tbd/auth/register/register.dart';

part 'register.freezed.dart';
part 'register.g.dart';

@freezed
class RegisterBody with _$RegisterBody {
  const factory RegisterBody({
    required String username,
    required String email,
    required String password,
  }) = _RegisterBody;

  factory RegisterBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterBodyFromJson(json);
}

@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String bearerToken,
    required String renewalToken,
    required String expiresAt,
    required String renewalExpiresAt,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
