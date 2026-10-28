import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';

part 'login_use_case.freezed.dart';

@freezed
abstract class LoginParams with _$LoginParams {
  const factory LoginParams({
    required String username,
    required String password,
  }) = _LoginParams;
}

@lazySingleton
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureResult<UserEntity> call(LoginParams params) => _repository.login(
    username: params.username.trim(),
    password: params.password,
  );
}
