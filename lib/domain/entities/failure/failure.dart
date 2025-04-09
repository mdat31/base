abstract class Failure {
  final String message;
  final int? errorCode;
  final Object? exception;

  Failure({
    required this.message,
    this.errorCode,
    this.exception,
  });
}
