import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureResult<UserEntity> call(NoParams params) =>
      _repository.getCurrentUser();
}
