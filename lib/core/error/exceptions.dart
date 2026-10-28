/// Exceptions thrown by the data layer. Repositories translate them into
/// [Failure]s (see `runGuarded`) so they never reach presentation.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode, super.cause});

  final int? statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized', Object? cause])
    : super(cause: cause);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No connection', Object? cause])
    : super(cause: cause);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'Request timed out',
    Object? cause,
  ]) : super(cause: cause);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error', Object? cause])
    : super(cause: cause);
}
