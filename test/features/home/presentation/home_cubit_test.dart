import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mod/features/home/presentation/cubit/home_cubit.dart';

import '../../../helpers/fixtures.dart';

class _MockGetCurrentUser extends Mock implements GetCurrentUserUseCase {}

void main() {
  late _MockGetCurrentUser getCurrentUser;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() => getCurrentUser = _MockGetCurrentUser());

  blocTest<HomeCubit, HomeState>(
    'loads the current user',
    setUp: () =>
        when(() => getCurrentUser(any()))
            .thenAnswer((_) async => const Right(tUser)),
    build: () => HomeCubit(getCurrentUser),
    act: (cubit) => cubit.load(),
    expect: () => const [HomeState.loaded(tUser)],
  );

  blocTest<HomeCubit, HomeState>(
    'retry shows loading again after a failure',
    setUp: () =>
        when(() => getCurrentUser(any()))
            .thenAnswer((_) async => const Right(tUser)),
    build: () => HomeCubit(getCurrentUser),
    seed: () => const HomeState.failure(Failure.network()),
    act: (cubit) => cubit.load(),
    expect: () => const [HomeState.loading(), HomeState.loaded(tUser)],
  );

  blocTest<HomeCubit, HomeState>(
    'emits failure',
    setUp: () =>
        when(() => getCurrentUser(any()))
            .thenAnswer((_) async => const Left(Failure.timeout())),
    build: () => HomeCubit(getCurrentUser),
    act: (cubit) => cubit.load(),
    expect: () => const [HomeState.failure(Failure.timeout())],
  );

  blocTest<HomeCubit, HomeState>(
    'refresh keeps current data visible',
    setUp: () =>
        when(() => getCurrentUser(any()))
            .thenAnswer((_) async => const Right(tUser)),
    build: () => HomeCubit(getCurrentUser),
    seed: () => const HomeState.loaded(tUser),
    act: (cubit) => cubit.load(),
    expect: () => const <HomeState>[],
  );
}
