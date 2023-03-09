import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/models/renew.dart';

import '../models/api_client.dart';
import '../models/register.dart';
import '../services/api_client.dart';
import '../utils/constants.dart';

final dioProvider = Provider((ref) => Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        contentType: "application/json",
        connectTimeout: Constants.timeout,
        receiveTimeout: Constants.timeout,
      ),
    )
      ..httpClientAdapter
      ..interceptors.addAll(
          [LoggerInterceptor(), AccessInterceptor(ref), AgentInterceptor()]));

final apiClientProvider =
    Provider<ApiClient>((ref) => ApiClient(ref.read(dioProvider)));

final logoutProvider = FutureProvider.autoDispose<ApiResponse>(
  (ref) async {
    final apiService = ref.watch(apiClientProvider);
    final response = await apiService.logout();
    return response;
  },
  name: 'logoutProvider',
  dependencies: [apiClientProvider],
);

final registerProvider =
    FutureProvider.family.autoDispose<ApiResponse, RegisterBody>(
  (ref, body) async {
    final apiService = ref.watch(apiClientProvider);
    final response = await apiService.register(body);
    return response;
  },
  name: 'registerProvider',
  dependencies: [apiClientProvider],
);

final loginProvider =
    FutureProvider.family.autoDispose<ApiResponse<LoginResponse?>, LoginBody>(
  (ref, body) {
    final apiService = ref.watch(apiClientProvider);

    return apiService.login(body);
  },
  name: 'loginProvider',
  dependencies: [apiClientProvider],
);

final verifyEmailProvider =
    FutureProvider.family.autoDispose<ApiResponse<LoginResponse?>, String>(
  (ref, query) {
    final apiService = ref.watch(apiClientProvider);

    return apiService.verifyEmail(query);
  },
  name: 'verifyEmailProvider',
  dependencies: [apiClientProvider],
);

final renewProvider = FutureProvider.autoDispose(
  (ref) {
    final apiService = ref.watch(apiClientProvider);

    return (RenewBody body) => apiService.renew(body);
  },
  name: 'renewProvider',
  dependencies: [apiClientProvider],
);

final myDetailsProvider = FutureProvider.autoDispose(
  (ref) {
    final apiService = ref.watch(apiClientProvider);
    return apiService.getMyDetails();
  },
  name: 'myDetailsProvider',
  dependencies: [apiClientProvider],
);
