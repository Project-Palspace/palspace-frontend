import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class LoginBody with _$LoginBody {
  const factory LoginBody({
    required String email,
    required String password,
  }) = _LoginBody;

  factory LoginBody.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyFromJson(json);
}
