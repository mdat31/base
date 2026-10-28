import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase implements UseCase<Unit, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureResult<Unit> call(NoParams params) => _repository.logout();
}
