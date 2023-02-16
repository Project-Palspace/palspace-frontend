import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/models/login.dart';
import 'package:tbd/models/renew.dart';

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
      ..interceptors.addAll([
        LoggerInterceptor(),
        // AccessInterceptor(ref),
      ]));

final apiClientProvider =
    Provider<ApiClient>((ref) => ApiClient(ref.read(dioProvider)));

final registerProvider = FutureProvider((ref) {
  final apiService = ref.watch(apiClientProvider);

  return (RegisterBody body) => apiService.register(body);
});

final loginProvider = FutureProvider((ref) {
  final apiService = ref.watch(apiClientProvider);

  return (LoginBody body) => apiService.login(body);
});

final renewProvider = FutureProvider((ref) {
  final apiService = ref.watch(apiClientProvider);

  return (RenewBody body) => apiService.renew(body);
});
