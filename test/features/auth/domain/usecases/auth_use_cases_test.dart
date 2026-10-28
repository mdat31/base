import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';
import 'package:mod/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mod/features/auth/domain/usecases/login_use_case.dart';
import 'package:mod/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mod/features/auth/domain/usecases/watch_auth_status_use_case.dart';

import '../../../../helpers/fixtures.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  test('LoginUseCase trims username and delegates', () async {
    when(() => repository.login(username: 'emilys', password: ' pass '))
        .thenAnswer((_) async => const Right(tUser));

    final result = await LoginUseCase(repository)(
      const LoginParams(username: '  emilys ', password: ' pass '),
    );

    expect(result, const Right<Failure, UserEntity>(tUser));
  });

  test('LogoutUseCase delegates', () async {
    when(() => repository.logout()).thenAnswer((_) async => const Right(unit));

    expect(
      await LogoutUseCase(repository)(const NoParams()),
      const Right<Failure, Unit>(unit),
    );
  });

  test('GetCurrentUserUseCase forwards failures', () async {
    when(() => repository.getCurrentUser())
        .thenAnswer((_) async => const Left(Failure.network()));

    expect(
      await GetCurrentUserUseCase(repository)(const NoParams()),
      const Left<Failure, UserEntity>(Failure.network()),
    );
  });

  test('WatchAuthStatusUseCase exposes the repository stream', () {
    when(() => repository.watchStatus())
        .thenAnswer((_) => Stream.value(AuthStatus.authenticated));

    expect(
      WatchAuthStatusUseCase(repository)(const NoParams()),
      emits(AuthStatus.authenticated),
    );
  });
}
