import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _SecureStoreKeys {
  static const String refreshToken = "refreshToken";
  static const String bearerToken = "bearerToken";
  static const String expiresAt = "expiresAt";
  static const String refreshExpiresAt = "refreshExpiresAt";
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

  Future<String?> fetchRefreshToken() async {
    return _storage.read(key: _SecureStoreKeys.refreshToken);
  }

  Future<String?> fetchRefreshTokenExpirationDateTime() async {
    return _storage.read(key: _SecureStoreKeys.refreshExpiresAt);
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

  Future<void> saveRefreshToken(String? refreshToken) async {
    await _storage.write(
      key: _SecureStoreKeys.refreshToken,
      value: refreshToken,
    );
  }

  Future<void> saveRefreshTokenExpirationDateTime(
    DateTime? refreshTokenExpirationDate,
  ) async {
    await _storage.write(
      key: _SecureStoreKeys.refreshExpiresAt,
      value: refreshTokenExpirationDate?.toIso8601String(),
    );
  }

  Future<void> deleteTokensData() async {
    await Future.wait([
      saveBearerToken(null),
      saveBearerTokenExpirationDateTime(null),
      saveRefreshToken(null),
      saveRefreshTokenExpirationDateTime(null),
    ]);
  }
}
