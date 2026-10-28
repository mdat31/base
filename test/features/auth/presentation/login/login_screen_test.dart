import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:mod/features/auth/presentation/login/screens/login_screen.dart';
import 'package:mod/features/auth/presentation/login/widgets/login_form.dart';

import '../../../../helpers/pump_app.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late _MockLoginCubit cubit;

  setUp(() {
    cubit = _MockLoginCubit();
    when(() => cubit.state).thenReturn(const LoginState.initial());
    when(
      () => cubit.submit(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, {bool showDemoHint = false}) =>
      tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: cubit,
          child: LoginScreen(showDemoHint: showDemoHint),
        ),
      );

  testWidgets('shows validation errors and does not submit', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(find.text(l10nEn.usernameRequired), findsOneWidget);
    expect(
      find.text(l10nEn.passwordTooShort(LoginForm.minPasswordLength)),
      findsOneWidget,
    );
    verifyNever(
      () => cubit.submit(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('submits valid credentials', (tester) async {
    await pump(tester);

    await tester.enterText(find.byKey(const Key('login_username')), 'emilys');
    await tester.enterText(
      find.byKey(const Key('login_password')),
      'emilyspass',
    );
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    verify(() => cubit.submit(username: 'emilys', password: 'emilyspass'))
        .called(1);
  });

  testWidgets('shows spinner while loading', (tester) async {
    when(() => cubit.state).thenReturn(const LoginState.loading());
    await pump(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows snackbar on failure', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const LoginState.loading(),
        const LoginState.failure(Failure.network()),
      ]),
      initialState: const LoginState.initial(),
    );
    await pump(tester);
    await tester.pump();

    expect(find.text(l10nEn.errorNetwork), findsOneWidget);
  });

  testWidgets('demo hint is optional', (tester) async {
    final hint = l10nEn.demoAccountHint(
      LoginForm.demoUsername,
      LoginForm.demoPassword,
    );

    await pump(tester);
    expect(find.text(hint), findsNothing);

    await pump(tester, showDemoHint: true);
    expect(find.text(hint), findsOneWidget);
  });
}
