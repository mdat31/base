import 'package:fpdart/fpdart.dart';
import 'package:mod/domain/entities/failure/failure.dart';

import '../../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  @override
  Future<Either<Failure, Unit>> signOut() {
    throw UnimplementedError();
  }
}
