import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late final int status;
  late final String message;

  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        status = 0;
        break;
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        message = "Connection has timed out.";
        status = 504;
        break;
      case DioErrorType.badResponse:
        message = _handleError(
          dioError.response!.headers['content-type']?[0],
          dioError.response!.statusCode,
          dioError.response!.data,
        );
        status = dioError.response!.statusCode ?? 400;
        break;
      default:
        message = "Something went wrong";
        status = 400;
        break;
    }
  }

  String _handleError(String? responseType, int? statusCode, dynamic error) {
    if (responseType != null && responseType.contains('text/html')) {
      switch (statusCode) {
        case 400:
          return 'Bad request';
        case 403:
          return 'Forbidden';
        case 404:
          return 'The requested data could not be found but may be available again in the future';
        case 500:
          return '500';
        case 429:
        case 502:
          return 'Our services are overloaded right now, please try again later';
        case 503:
          return 'Services are down momentarily while we perform maintenance, check back soon';
        default:
          return 'Oops something went wrong';
      }
    } else {
      switch (statusCode) {
        case 400:
          if (error is Map && error.isNotEmpty) {
            return error['error'];
          }
          return 'Bad request';
        case 403:
          return 'This is a private account!';
        case 404:
          return error['errors'][0]['message'];
        case 500:
          return 'We may have a bug, please report it at https://feedback.tracker.gg along with any helpful information, such as your profile username.';
        case 429:
        case 502:
          return 'Our services are overloaded right now, please try again later';
        case 503:
          return 'Services are down momentarily while we perform maintenance, check back soon';
        default:
          if (error is Map && error.isNotEmpty) {
            return 'Oops something went wrong $statusCode ${error['error']}';
          }
          return 'Oops something went wrong $statusCode}';
      }
    }
  }

  @override
  String toString() => message;
}
