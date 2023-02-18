import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/api_client.dart';
import 'package:tbd/providers/api_client.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/services/exceptions.dart';

import '../models/login.dart';
import '../models/register.dart';
import '../models/renew.dart';
import '../repository/token_repository.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> postReq(Future<Response> req) async {
    try {
      final response = await req;

      return response.data ?? {};
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      return {'error': error};
    }
  }

  Future<ApiResponse> register(RegisterBody body) async {
    final responseJson = await postReq(
      _dio.post<void>(
        '/user/register',
        data: body.toJson(),
      ),
    );

    final response = ApiResponse.fromJson(
        responseJson, (json) => LoginResponse.fromJson(json));

    return response;
  }

  Future<ApiResponse<LoginResponse>> login(LoginBody body) async {
    final responseJson = await postReq(
      _dio.post<void>(
        '/user/login',
        data: body.toJson(),
      ),
    );

    final response = ApiResponse.fromJson(
        responseJson, (json) => LoginResponse.fromJson(json));

    return response;
  }

  Future<ApiResponse<LoginResponse>> renew(RenewBody body) async {
    final response = await postReq(
      _dio.post<void>(
        '/user/renew',
        data: body.toJson(),
      ),
    );
    return ApiResponse.fromJson(
        response, (json) => LoginResponse.fromJson(json));
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('${options.method} ${options.uri}');
    return handler.next(options);
  }
}

class AccessInterceptor extends QueuedInterceptor {
  final Ref _ref;

  AccessInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokenRepo = _ref.read(tokenRepositoryProvider);
    String? bearerToken = await tokenRepo.fetchBearerToken();

    Duration expiration = Duration.zero;
    Duration refreshExpiration = Duration.zero;
    final bearerTokenExp = await tokenRepo.fetchBearerTokenExpirationDateTime();
    if (bearerTokenExp != null) {
      expiration = DateTime.parse(bearerTokenExp).difference(DateTime.now());
    }
    final refreshTokenExp =
        await tokenRepo.fetchBearerTokenExpirationDateTime();
    if (refreshTokenExp != null) {
      expiration = DateTime.parse(refreshTokenExp).difference(DateTime.now());
    }

    if (refreshExpiration.inSeconds < 60) {
      if (expiration.inSeconds < 60) {
        String? refreshToken;

        try {
          refreshToken = await tokenRepo.fetchRefreshToken();

          LoginResponse? response;
          if (refreshToken != null) {
            final resp = await _ref
                .read(apiClientProvider)
                .renew(RenewBody(renewToken: refreshToken));

            if (resp.error != null) {
              _ref
                  .read(authStateNotifierProvider.notifier)
                  .logout(userInitiated: false);
              return handler.reject(DioError(requestOptions: options));
            }
            if (resp.data != null) {
              response = resp.data!;
              await tokenRepo.saveBearerToken(response.token);
              await tokenRepo.saveRefreshToken(response.refreshToken);
              await tokenRepo.saveBearerTokenExpirationDateTime(
                DateTime.parse(response.expiresAt!),
              );
              await tokenRepo.saveRefreshTokenExpirationDateTime(
                DateTime.tryParse(response.refreshExpiresAt!),
              );
              bearerToken = response.token;
            }
          }
        } catch (e) {
          return handler.reject(DioError(requestOptions: options, error: e));
        }

        options.headers[HttpHeaders.authorizationHeader] =
            "Bearer $bearerToken";

        return handler.next(options);
      }

      _ref
          .read(authStateNotifierProvider.notifier)
          .logout(userInitiated: false);
      return handler.reject(DioError(requestOptions: options));
    }
  }
}
