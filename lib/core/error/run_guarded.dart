import 'package:dio/dio.dart';
import 'package:mod/core/error/exceptions.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/network/dio_exception_mapper.dart';

/// Runs [action] and converts anything thrown into a [Failure].
///
/// Use it in every repository method so error mapping lives in one place.
Future<Result<T>> runGuarded<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on DioException catch (error) {
    return Left(mapExceptionToFailure(mapDioException(error)));
  } on AppException catch (error) {
    return Left(mapExceptionToFailure(error));
  } on Object catch (error) {
    return Left(Failure.unexpected(message: error.toString()));
  }
}

Failure mapExceptionToFailure(AppException exception) => switch (exception) {
  ServerException(:final message, :final statusCode) => Failure.server(
    message: message,
    statusCode: statusCode,
  ),
  UnauthorizedException(:final message) => Failure.unauthorized(
    message: message,
  ),
  NetworkException(:final message) => Failure.network(message: message),
  RequestTimeoutException(:final message) => Failure.timeout(message: message),
  CacheException(:final message) => Failure.cache(message: message),
};
