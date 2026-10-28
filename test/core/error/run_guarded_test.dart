import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/error/exceptions.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/error/run_guarded.dart';

void main() {
  test('returns Right with the value on success', () async {
    expect(await runGuarded(() async => 42), const Right<Failure, int>(42));
  });

  test('maps DioException to a Failure', () async {
    final result = await runGuarded<int>(
      () => throw DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('maps unknown errors to UnexpectedFailure', () async {
    final result = await runGuarded<int>(() => throw StateError('bad'));

    expect(result.getLeft().toNullable(), isA<UnexpectedFailure>());
  });

  group('mapExceptionToFailure', () {
    test('covers every AppException', () {
      expect(
        mapExceptionToFailure(const ServerException('x', statusCode: 500)),
        const Failure.server(message: 'x', statusCode: 500),
      );
      expect(
        mapExceptionToFailure(const UnauthorizedException()),
        isA<UnauthorizedFailure>(),
      );
      expect(
        mapExceptionToFailure(const NetworkException()),
        isA<NetworkFailure>(),
      );
      expect(
        mapExceptionToFailure(const RequestTimeoutException()),
        isA<TimeoutFailure>(),
      );
      expect(
        mapExceptionToFailure(const CacheException()),
        isA<CacheFailure>(),
      );
    });
  });

  test('AppException.toString includes type and message', () {
    expect(const CacheException('disk').toString(), contains('disk'));
  });
}
