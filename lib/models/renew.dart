import 'package:freezed_annotation/freezed_annotation.dart';

part 'renew.freezed.dart';
part 'renew.g.dart';

@freezed
class RenewBody with _$RenewBody {
  const factory RenewBody({
    required String renewToken,
  }) = _RenewBody;

  factory RenewBody.fromJson(Map<String, dynamic> json) =>
      _$RenewBodyFromJson(json);
}
