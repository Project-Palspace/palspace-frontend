import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    String? username,
    String? email,
    Details? details,
    Facts? facts,
    List<String>? traits,
    String? profilePictureUrl,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

@freezed
class Details with _$Details {
  const factory Details({
    String? bio,
    String? currentCity,
    String? homeCity,
  }) = _Details;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
}

@freezed
class Facts with _$Facts {
  const factory Facts({
    String? firstName,
    String? lastName,
    String? nationality,
    DateTime? birthDate,
  }) = _Facts;

  factory Facts.fromJson(Map<String, dynamic> json) => _$FactsFromJson(json);
}
