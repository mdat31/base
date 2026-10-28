import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/features/home/presentation/cubit/home_cubit.dart';
import 'package:mod/features/home/presentation/screens/home_screen.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late _MockHomeCubit cubit;

  setUp(() {
    cubit = _MockHomeCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, HomeState state) {
    when(() => cubit.state).thenReturn(state);
    return tester.pumpApp(
      BlocProvider<HomeCubit>.value(value: cubit, child: const HomeScreen()),
    );
  }

  testWidgets('shows loading', (tester) async {
    await pump(tester, const HomeState.loading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the profile', (tester) async {
    await pump(tester, const HomeState.loaded(tUser));

    expect(find.text(l10nEn.homeGreeting('Emily')), findsOneWidget);
    expect(find.text(tUser.email), findsOneWidget);
    expect(find.text(tUser.username), findsOneWidget);
  });

  testWidgets('shows error and retries', (tester) async {
    await pump(tester, const HomeState.failure(Failure.network()));

    expect(find.text(l10nEn.errorNetwork), findsOneWidget);
    await tester.tap(find.text(l10nEn.retry));
    verify(() => cubit.load()).called(1);
  });
}
