import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tbd/models/api_client.dart';
import 'package:tbd/services/exceptions.dart';

import '../models/login.dart';
import '../models/register.dart';
import '../models/renew.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse> postReq(Future<Response> req) async {
    try {
      final response = await req;

      return ApiResponse.success(response.data);
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      return ApiResponse.error(error.message);
    }
  }

  Future<ApiResponse> register(RegisterBody body) async {
    return await postReq(
      _dio.post<void>(
        '/user/register',
        data: body.toJson(),
      ),
    );
  }

  Future<ApiResponse> login(LoginBody body) async {
    return await postReq(
      _dio.post<void>(
        '/user/login',
        data: body.toJson(),
      ),
    );
  }

  Future<ApiResponse> renew(RenewBody body) async {
    return await postReq(
      _dio.post<void>(
        '/user/renew',
        data: body.toJson(),
      ),
    );
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('${options.method} ${options.uri}');
    return handler.next(options);
  }
}
