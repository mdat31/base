import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/features/auth/domain/usecases/login_use_case.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';

import '../../../../helpers/fixtures.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late _MockLoginUseCase login;

  setUpAll(
    () => registerFallbackValue(const LoginParams(username: '', password: '')),
  );

  setUp(() => login = _MockLoginUseCase());

  test('initial state', () {
    expect(LoginCubit(login).state, const LoginState.initial());
  });

  blocTest<LoginCubit, LoginState>(
    'emits loading then success',
    setUp: () =>
        when(() => login(any())).thenAnswer((_) async => const Right(tUser)),
    build: () => LoginCubit(login),
    act: (cubit) => cubit.submit(username: 'u', password: 'p'),
    expect: () => const [LoginState.loading(), LoginState.success()],
    verify: (_) =>
        verify(() => login(const LoginParams(username: 'u', password: 'p')))
            .called(1),
  );

  blocTest<LoginCubit, LoginState>(
    'emits loading then failure',
    setUp: () =>
        when(() => login(any()))
            .thenAnswer((_) async => const Left(Failure.network())),
    build: () => LoginCubit(login),
    act: (cubit) => cubit.submit(username: 'u', password: 'p'),
    expect: () => const [
      LoginState.loading(),
      LoginState.failure(Failure.network()),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'ignores submit while loading',
    build: () => LoginCubit(login),
    seed: () => const LoginState.loading(),
    act: (cubit) => cubit.submit(username: 'u', password: 'p'),
    expect: () => const <LoginState>[],
    verify: (_) => verifyNever(() => login(any())),
  );
}
