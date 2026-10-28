import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mod/core/error/exceptions.dart';

/// Translates transport errors into [AppException]s.
AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return RequestTimeoutException('Request timed out', error);
    case DioExceptionType.connectionError:
      return NetworkException('No connection', error);
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final message =
          _messageFrom(error.response?.data) ?? error.message ?? 'Server error';
      if (statusCode == HttpStatus.unauthorized) {
        return UnauthorizedException(message, error);
      }
      return ServerException(message, statusCode: statusCode, cause: error);
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      if (error.error is SocketException) {
        return NetworkException('No connection', error);
      }
      return ServerException(error.message ?? 'Unknown error', cause: error);
  }
}

String? _messageFrom(Object? data) {
  if (data is Map) {
    final message = data['message'] ?? data['error'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
