import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/api_client.dart';
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

      return response.data;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      return {'error': error};
    }
  }

  Future<ApiResponse<LoginResponse>> register(RegisterBody body) async {
    final response = await postReq(
      _dio.post<void>(
        '/user/register',
        data: body.toJson(),
      ),
    );

    return ApiResponse.fromJson(
        response, (json) => LoginResponse.fromJson(json));
  }

  Future<ApiResponse> login(LoginBody body) async {
    final response = await postReq(
      _dio.post<void>(
        '/user/login',
        data: body.toJson(),
      ),
    );
    return ApiResponse.fromJson(
        response, (json) => LoginResponse.fromJson(json));
  }

  Future<ApiResponse> renew(RenewBody body) async {
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

// class AccessInterceptor extends QueuedInterceptor {
//   final Ref _ref;

//   AccessInterceptor(this._ref);

//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final tokenRepo = _ref.read(tokenRepositoryProvider);
//     String? accessToken = await tokenRepo.fetchBearerToken();

//     // all requests made with [SecureHttp] require a accessToken
//     // so we must reject this request
//     if (accessToken == null) {
//       handler.reject(DioError(requestOptions: options));
//       return;
//     }

//     Duration expiration = Duration.zero;
//     final accessTokenExp = await tokenRepo.fetchBearerTokenExpirationDateTime();
//     if (accessTokenExp != null) {
//       expiration = DateTime.parse(accessTokenExp).difference(DateTime.now());
//     }

//     if (expiration.inSeconds < 60) {
//       String? renewalToken;
//       try {
//         renewalToken = await tokenRepo.fetchRenewalToken();
//         LoginResponse? response;
//         if (renewalToken != null) {
//           response = await _ref
//               .read(authStateNotifierProvider.notifier)
//               .refresh(renewalToken);
//         }

//         if (response == null) {
//           await _ref
//               .read(authStateNotifierProvider.notifier)
//               .logout(userInitiated: false);
//           return handler.reject(DioError(requestOptions: options));
//         }

//         await tokenRepo.saveBearerToken(response.accessToken);
//         await tokenRepo.saveRenewalToken(response.renewalToken);
//         await tokenRepo.saveBearerTokenExpirationDateTime(
//           response.TokenExpirationDateTime,
//         );

//         accessToken = response.accessToken;
//       } catch (e, s) {
//         FirebaseCrashlytics.instance.recordError(
//           e,
//           s,
//           reason: "New Auth Refresh Error",
//           information: [
//             StringProperty('refreshToken', renewalToken),
//             StringProperty('accessToken', accessToken),
//           ],
//         );
//         return handler.reject(DioError(requestOptions: options, error: e));
//       }
//     }

//     // all requests made with [SecureHttp] require a accessToken
//     // so we must reject this request
//     if (accessToken == null) {
//       handler.reject(DioError(requestOptions: options));
//       return;
//     }

//     options.headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";

//     return handler.next(options);
//   }
// }
