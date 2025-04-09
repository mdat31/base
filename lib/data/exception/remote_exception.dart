import '../../domain/entities/failure/failure.dart';

class RemoteException extends Failure {
  RemoteException({
    required super.message,
    super.errorCode,
    super.exception,
  });
}
