import 'package:equatable/equatable.dart';
import 'package:tbd/services/exceptions.dart';

class ApiResponse<T> extends Equatable {
  final DioExceptions? error;
  final T? data;
  const ApiResponse({
    this.error,
    this.data,
  });

  T get dataOrThrow => data ?? (throw error!);

  factory ApiResponse.fromJson(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic> json) create,
  ) {
    return ApiResponse<T>(
      error: map['error'],
      data: map['data'] != null ? create(map['data']) : null,
    );
  }

  factory ApiResponse.success(T? data) => ApiResponse<T>(data: data);

  factory ApiResponse.error(DioExceptions error) =>
      ApiResponse<T>(error: error);

  @override
  List<Object?> get props => [error, data];
}
