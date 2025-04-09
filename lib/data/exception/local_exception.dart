
import '../../domain/entities/failure/failure.dart';

class LocalException extends Failure {
  LocalException({
    required super.message,
    super.errorCode,
    super.exception,
  });
}
