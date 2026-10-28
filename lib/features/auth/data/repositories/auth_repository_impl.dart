import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/error/run_guarded.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';
import 'package:mod/core/storage/token_storage.dart';
import 'package:mod/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remote,
    this._tokenStorage,
    SessionExpiryNotifier sessionExpiryNotifier,
  ) {
    _expirySubscription = sessionExpiryNotifier.onExpired.listen(
      (_) => _statusController.add(AuthStatus.unauthenticated),
    );
  }

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final _statusController = StreamController<AuthStatus>.broadcast();
  late final StreamSubscription<void> _expirySubscription;

  @override
  Stream<AuthStatus> watchStatus() async* {
    final tokens = await _tokenStorage.read();
    yield tokens == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    yield* _statusController.stream;
  }

  @override
  FutureResult<UserEntity> login({
    required String username,
    required String password,
  }) => runGuarded(() async {
    final response = await _remote.login(
      LoginRequest(username: username, password: password),
    );
    await _tokenStorage.save(response.toTokens());
    _statusController.add(AuthStatus.authenticated);
    return response.toEntity();
  });

  @override
  FutureResult<Unit> logout() => runGuarded(() async {
    await _tokenStorage.clear();
    _statusController.add(AuthStatus.unauthenticated);
    return unit;
  });

  @override
  FutureResult<UserEntity> getCurrentUser() =>
      runGuarded(() async => (await _remote.getCurrentUser()).toEntity());

  /// App-lifetime singleton; exposed for tests and scoped containers.
  Future<void> dispose() async {
    await _expirySubscription.cancel();
    await _statusController.close();
  }
}
