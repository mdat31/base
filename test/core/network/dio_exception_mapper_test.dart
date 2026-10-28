import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/error/exceptions.dart';
import 'package:mod/core/network/dio_exception_mapper.dart';

void main() {
  final options = RequestOptions(path: '/test');

  DioException error(
    DioExceptionType type, {
    int? statusCode,
    Object? data,
    Object? cause,
  }) => DioException(
    requestOptions: options,
    type: type,
    error: cause,
    response: statusCode == null
        ? null
        : Response<Object?>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );

  test('maps timeouts', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      expect(mapDioException(error(type)), isA<RequestTimeoutException>());
    }
  });

  test('maps connection errors and sockets to NetworkException', () {
    expect(
      mapDioException(error(DioExceptionType.connectionError)),
      isA<NetworkException>(),
    );
    expect(
      mapDioException(
        error(
          DioExceptionType.unknown,
          cause: const SocketException('offline'),
        ),
      ),
      isA<NetworkException>(),
    );
  });

  test('maps 401 to UnauthorizedException with server message', () {
    final result = mapDioException(
      error(
        DioExceptionType.badResponse,
        statusCode: 401,
        data: {'message': 'Invalid credentials'},
      ),
    );

    expect(result, isA<UnauthorizedException>());
    expect(result.message, 'Invalid credentials');
  });

  test('maps other bad responses to ServerException with status', () {
    final result = mapDioException(
      error(
        DioExceptionType.badResponse,
        statusCode: 500,
        data: {'error': 'Boom'},
      ),
    );

    expect(
      result,
      isA<ServerException>()
          .having((e) => e.statusCode, 'statusCode', 500)
          .having((e) => e.message, 'message', 'Boom'),
    );
  });

  test('falls back to a generic message when body has none', () {
    final result = mapDioException(
      error(DioExceptionType.badResponse, statusCode: 404, data: 'oops'),
    );

    expect(result, isA<ServerException>());
    expect(result.message, isNotEmpty);
  });

  test('maps cancel/unknown to ServerException', () {
    expect(
      mapDioException(error(DioExceptionType.cancel)),
      isA<ServerException>(),
    );
  });
}
