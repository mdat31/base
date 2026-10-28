import 'package:mod/core/error/result.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  /// Emits the current status first, then every change.
  Stream<AuthStatus> watchStatus();

  FutureResult<UserEntity> login({
    required String username,
    required String password,
  });

  FutureResult<Unit> logout();

  FutureResult<UserEntity> getCurrentUser();
}
