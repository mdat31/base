import 'package:fpdart/fpdart.dart';
import 'package:mod/domain/repositories/authentication_repository.dart';

import '../entities/failure/failure.dart';

class SignOutUseCase {
  final AuthenticationRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
