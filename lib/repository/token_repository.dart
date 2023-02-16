import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _SecureStoreKeys {
  static const String renewalToken = "renewalToken";
  static const String bearerToken = "bearerToken";
  static const String expiresAt = "expiresAt";
  static const String renewalExpiresAt = "renewalExpiresAt";
}

final tokenRepositoryProvider = Provider(
  (ref) => TokenRepository(),
  name: 'tokenRepositoryProvider',
);

class TokenRepository {
  static const _storage = FlutterSecureStorage();

  Future<String?> fetchBearerToken() async {
    return _storage.read(key: _SecureStoreKeys.bearerToken);
  }

  Future<String?> fetchBearerTokenExpirationDateTime() async {
    return _storage.read(key: _SecureStoreKeys.expiresAt);
  }

  Future<String?> fetchRenewalToken() async {
    return _storage.read(key: _SecureStoreKeys.renewalToken);
  }

  Future<String?> fetchRenewalTokenExpirationDateTime() async {
    return _storage.read(key: _SecureStoreKeys.renewalExpiresAt);
  }

  Future<void> saveBearerToken(String? bearerToken) async {
    await _storage.write(
      key: _SecureStoreKeys.bearerToken,
      value: bearerToken,
    );
  }

  Future<void> saveBearerTokenExpirationDateTime(
    DateTime? bearerTokenExpirationDate,
  ) async {
    await _storage.write(
      key: _SecureStoreKeys.expiresAt,
      value: bearerTokenExpirationDate?.toIso8601String(),
    );
  }

  Future<void> saveRenewalToken(String? renewalToken) async {
    await _storage.write(
      key: _SecureStoreKeys.renewalToken,
      value: renewalToken,
    );
  }

  Future<void> saveRenewalTokenExpirationDateTime(
    DateTime? renewalTokenExpirationDate,
  ) async {
    await _storage.write(
      key: _SecureStoreKeys.renewalExpiresAt,
      value: renewalTokenExpirationDate?.toIso8601String(),
    );
  }

  Future<void> deleteTokensData() async {
    await Future.wait([
      saveBearerToken(null),
      saveBearerTokenExpirationDateTime(null),
      saveRenewalToken(null),
      saveRenewalTokenExpirationDateTime(null),
    ]);
  }
}
