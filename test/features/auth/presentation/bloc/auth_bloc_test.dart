import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mod/features/auth/domain/usecases/watch_auth_status_use_case.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';

class _MockWatchAuthStatus extends Mock implements WatchAuthStatusUseCase {}

class _MockLogout extends Mock implements LogoutUseCase {}

void main() {
  late _MockWatchAuthStatus watchAuthStatus;
  late _MockLogout logout;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    watchAuthStatus = _MockWatchAuthStatus();
    logout = _MockLogout();
  });

  AuthBloc build() => AuthBloc(watchAuthStatus, logout);

  test('initial status is unknown', () {
    expect(build().state, const AuthState());
  });

  blocTest<AuthBloc, AuthState>(
    'mirrors the auth status stream',
    setUp: () => when(() => watchAuthStatus(any())).thenAnswer(
      (_) => Stream.fromIterable([
        AuthStatus.unauthenticated,
        AuthStatus.authenticated,
      ]),
    ),
    build: build,
    act: (bloc) => bloc.add(const AuthSubscriptionRequested()),
    expect: () => const [
      AuthState(status: AuthStatus.unauthenticated),
      AuthState(status: AuthStatus.authenticated),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'logout calls the use case',
    setUp: () =>
        when(() => logout(any())).thenAnswer((_) async => const Right(unit)),
    build: build,
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    expect: () => const <AuthState>[],
    verify: (_) => verify(() => logout(any())).called(1),
  );
}
