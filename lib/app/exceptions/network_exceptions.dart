import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as _get;

import '../routes/app_routes.dart';

abstract class NetworkExceptions {
  static String handleResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        _get.Get.offAllNamed(Routes.LOGIN);
        return "Unauthorized Request";
      case 404:
        return "Not found";
      case 408:
        return "Connection request timeout";
      case 409:
        return "Error due to a conflict";
      case 500:
        return "Internal Server Error";
      case 503:
        return "Service unavailable";
      default:
        return "Received invalid status code";
    }
  }

  static String getDioException(dynamic error) {
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.cancel:
            return "Request Cancelled";

          case DioExceptionType.connectionTimeout:
            return "Connection request timeout";

          case DioExceptionType.sendTimeout:
            return "Send timeout in connection with API server";

          case DioExceptionType.receiveTimeout:
            return "Receive timeout in connection with API server";

          case DioExceptionType.badResponse:
            return handleResponse(error.response);

          case DioExceptionType.connectionError:
            return "No internet connection";

          case DioExceptionType.unknown:
          default:
            return "Unexpected error occurred";
        }
      }

      if (error is SocketException) {
        return "No internet connection";
      }

      if (error.toString().contains("is not a subtype of")) {
        return "Unable to process the data";
      }

      return "Unexpected error occurred";
    } catch (_) {
      return "Unexpected error occurred";
    }
  }
}
