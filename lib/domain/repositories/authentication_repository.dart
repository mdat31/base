import 'package:fpdart/fpdart.dart';

import '../entities/failure/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Unit>> signOut();
}
