import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'login.dart';
import 'register.dart';
import 'renew.dart';

part 'api_client.freezed.dart';

@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success(T data) = _Success<T>;
  const factory ApiResponse.error(String message) = _Error<T>;
}

@freezed
class ApiError with _$ApiError {
  const factory ApiError.networkError(DioError error) = _NetworkError;
  const factory ApiError.badRequest(String message) = _BadRequest;
}

// extension ApiErrorMessage on ApiError {
//   String get message => when(
//     networkError: (error) => ,
//   )
// }

// @freezed
// class ApiClient with _$ApiClient {
//   const ApiClient._();

//   factory ApiClient(Dio dio) = _ApiClient;
// }

// @freezed
// class Endpoints with _$Endpoints {
//   const Endpoints._();

//   factory Endpoints(Dio dio) = _Endpoints;

//   @POST('/user/register')
//   Future<ApiResponse<void>> register(
//     @Body() RegisterBody body,
//   );

//   @POST('/user/login')
//   Future<ApiResponse<void>> login(
//     @Body() LoginBody body,
//   );

//   @POST('/user/renew')
//   Future<ApiResponse<void>> renew(
//     @Body() RenewBody body,
//   );

//   @GET('/admin/users')
//   Future<ApiResponse<void>> getTable();

//   @GET('/example')
//   Future<ApiResponse<void>> example();
// }
