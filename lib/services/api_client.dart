import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tbd/models/api_client.dart';
import 'package:tbd/models/user_details.dart';
import 'package:tbd/providers/api_client.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/services/exceptions.dart';
import 'package:tbd/utils/device_info.dart';

import '../models/login.dart';
import '../models/register.dart';
import '../models/renew.dart';
import '../repository/token_repository.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  static Future<String> buildUserAgentHeader() async {
    final pckgInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await DeviceInfo().getDeviceInfo();
    return "Palspace / ${pckgInfo.version} / $deviceInfo";
  }

  Future<Map<String, dynamic>> sentReq(Future<Response> req) async {
    try {
      final response = await req;
      print(response);
      return response.data ?? {};
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      return {'error': error};
    }
  }

  Future<ApiResponse> logout() async {
    final responseJson = await sentReq(
      _dio.get<void>(
        '/user/manage/logout',
      ),
    );

    final response = ApiResponse.fromJson(responseJson, (json) => json);
    print(response);

    return response;
  }

  Future<ApiResponse> register(RegisterBody body) async {
    final responseJson = await sentReq(
      _dio.post<void>(
        '/user/register',
        data: body.toJson(),
      ),
    );

    final response = ApiResponse.fromJson(responseJson, (json) => json);
    print(response);
    return response;
  }

  Future<ApiResponse<LoginResponse>> login(LoginBody body) async {
    final responseJson = await sentReq(
      _dio.post<void>(
        '/user/login',
        data: body.toJson(),
      ),
    );

    final response = ApiResponse.fromJson(
        responseJson, (json) => LoginResponse.fromJson(json));

    return response;
  }

  Future<ApiResponse<LoginResponse>> verifyEmail(String token) async {
    final responseJson = await sentReq(
      _dio.get<void>('/user/verify-email', queryParameters: {
        't': token,
      }),
    );

    final response = ApiResponse.fromJson(
        responseJson, (json) => LoginResponse.fromJson(json));

    return response;
  }

  Future<ApiResponse<LoginResponse>> renew(RenewBody body) async {
    final response = await sentReq(
      _dio.post<void>(
        '/user/renew',
        data: body.toJson(),
      ),
    );
    return ApiResponse.fromJson(
        response, (json) => LoginResponse.fromJson(json));
  }

  Future<ApiResponse<UserDetails>> getMyDetails() async {
    final responseJson = await sentReq(
      _dio.get<void>('/user/details/'),
    );

    final response = ApiResponse.fromJson(
        responseJson, (json) => UserDetails.fromJson(json));

    return response;
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('${options.method} ${options.uri}\n ${options.data}');
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
    String? bearerExp = await tokenRepo.fetchBearerTokenExpirationDateTime();

    String? refreshToken = await tokenRepo.fetchRefreshToken();
    String? refreshExp = await tokenRepo.fetchRefreshTokenExpirationDateTime();

    if (bearerToken != null) {
      Duration expiration = Duration.zero;
      Duration refreshExpiration = Duration.zero;
      if (bearerExp != null) {
        expiration = DateTime.parse(bearerExp).difference(DateTime.now());
      }

      if (refreshExp != null) {
        refreshExpiration =
            DateTime.parse(refreshExp).difference(DateTime.now());
      }

      if (refreshExpiration.inSeconds < 60) {
        _ref
            .read(authStateNotifierProvider.notifier)
            .logout(userInitiated: false);
        return handler.reject(DioError(requestOptions: options));
      }

      if (expiration.inSeconds < 60) {
        try {
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
      }
      options.headers[HttpHeaders.authorizationHeader] = "Bearer $bearerToken";
      return handler.next(options);
    }
    return handler.next(options);
  }
}

class AgentInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add User-Agent header with app and device information
    options.headers[HttpHeaders.userAgentHeader] =
        await ApiClient.buildUserAgentHeader();
    return handler.next(options);
  }
}
