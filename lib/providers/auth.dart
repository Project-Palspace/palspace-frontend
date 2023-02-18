import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/models/register.dart';
import 'package:tbd/providers/api_client.dart';

import '../repository/token_repository.dart';
import '../services/exceptions.dart';

part 'auth.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _InitialAuthState;

  const factory AuthState.loggedIn() = _LoggedInAuthState;

  const factory AuthState.loggedOut({
    required bool? userInitiated,
  }) = _LoggedOutAuthState;

  bool get isSignedIn => maybeMap(orElse: () => false, loggedIn: (_) => true);
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final tokenRepo = ref.watch(tokenRepositoryProvider);

    return AuthStateNotifier(
      tokenRepo: tokenRepo,
      ref: ref,
    );
  },
  name: 'authStateNotifierProvider',
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({
    required TokenRepository tokenRepo,
    required Ref ref,
  })  : _tokenRepo = tokenRepo,
        _ref = ref,
        super(const AuthState.initial());

  final TokenRepository _tokenRepo;
  final Ref _ref;

  bool _initialized = false;

  bool get isSignedIn => state.isSignedIn;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final accessToken = await _tokenRepo.fetchBearerToken();
    if (accessToken == null) {
      state = const AuthState.loggedOut(userInitiated: null);
      return;
    }

    await _afterSignIn();
  }

  Future<void> signUp(RegisterBody body) async {
    _assertInitialized();

    try {
      await _signUp(body);
      await _afterSignIn();
    } on PlatformException catch (e) {
      log('Error occured when signing up: $e');
      state = const AuthState.loggedOut(userInitiated: false);
    }
  }

  Future<void> signIn(LoginBody body) async {
    _assertInitialized();

    try {
      await _signIn(body);
      await _afterSignIn();
    } on PlatformException catch (e) {
      log('Error occured when signing in: $e');
      state = const AuthState.loggedOut(userInitiated: false);
    }
  }

  Future<void> logout({required bool userInitiated}) async {
    _assertInitialized();

    try {
      await _logout();
    } on DioExceptions catch (e) {
      if (e.status != 504) {
        state = AuthState.loggedOut(userInitiated: userInitiated);
      }
    }
    state = AuthState.loggedOut(userInitiated: userInitiated);
    await Future.wait<void>([
      _tokenRepo.deleteTokensData(),
    ]);
  }

  void _assertInitialized() {
    assert(_initialized, "Call initialize() first.");
  }

  Future<void> _afterSignIn() async {
    try {
      // final profile = await getProfile(ref: _ref);
      state = const AuthState.loggedIn();
    } on DioExceptions {
      state = const AuthState.loggedOut(userInitiated: false);
    }
  }

  Future<void> _logout() async {
    try {
      await _ref.read(
        logoutProvider.future,
      );

      // if (result.error == null) {
      //   //TODO: Navigate to email verification screen
      // } else {
      //   log(result.error!.message);
      // }
    } on PlatformException catch (e) {
      if (e.message?.toLowerCase().contains("cancelled") ?? false) return;
      rethrow;
    } catch (_) {}
  }

  Future<void> _signUp(RegisterBody body) async {
    try {
      final result = await _ref.read(
        registerProvider(body).future,
      );

      if (result.error == null) {
        //TODO: Navigate to email verification screen
      } else {
        log(result.error!.message);
      }
    } on PlatformException catch (e) {
      if (e.message?.toLowerCase().contains("cancelled") ?? false) return;
      rethrow;
    } catch (_) {}
  }

  Future<void> _signIn(LoginBody body) async {
    try {
      final result = await _ref.read(
        loginProvider(body).future,
      );
      if (result.error == null) {
        _saveTokens(result.data!);
      } else {
        log(result.error!.message);
      }
    } on PlatformException catch (e) {
      if (e.message?.toLowerCase().contains("cancelled") ?? false) return;
      rethrow;
    } catch (_) {}
  }

  Future<void> _saveTokens(
    LoginResponse response,
  ) async {
    final tokenRepo = _ref.read(tokenRepositoryProvider);

    final bearerToken = response.token;
    final refreshToken = response.refreshToken;
    final exp = response.expiresAt;
    final refreshExp = response.refreshExpiresAt;

    await tokenRepo.saveBearerToken(bearerToken);
    await tokenRepo.saveRefreshToken(refreshToken);
    await tokenRepo.saveBearerTokenExpirationDateTime(
        exp != null ? DateTime.parse(exp) : null);
    await tokenRepo.saveRefreshTokenExpirationDateTime(
        refreshExp != null ? DateTime.parse(refreshExp) : null);
  }
}
