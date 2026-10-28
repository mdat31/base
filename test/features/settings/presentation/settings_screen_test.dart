import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mod/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mod/features/settings/presentation/screens/settings_screen.dart';

import '../../../helpers/pump_app.dart';

class _MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockSettingsCubit settingsCubit;
  late _MockAuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const AuthLogoutRequested());
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    settingsCubit = _MockSettingsCubit();
    authBloc = _MockAuthBloc();
    when(() => settingsCubit.state).thenReturn(const SettingsState());
    when(() => authBloc.state).thenReturn(const AuthState());
    when(() => settingsCubit.changeThemeMode(any())).thenAnswer((_) async {});
    when(() => settingsCubit.changeLocale(any())).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    return tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: const SettingsScreen(),
      ),
    );
  }

  testWidgets('changes theme', (tester) async {
    await pump(tester);

    await tester.tap(find.text(l10nEn.themeDark));

    verify(() => settingsCubit.changeThemeMode(ThemeMode.dark)).called(1);
  });

  testWidgets('lists languages and changes locale', (tester) async {
    await pump(tester);

    expect(find.text(l10nEn.languageSystem), findsOneWidget);
    await tester.tap(find.text('Tiếng Việt'));
    verify(() => settingsCubit.changeLocale(const Locale('vi'))).called(1);

    await tester.tap(find.text(l10nEn.languageSystem));
    verify(() => settingsCubit.changeLocale(null)).called(1);
  });

  testWidgets('logout asks for confirmation first', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const Key('settings_logout')));
    await tester.pumpAndSettle();
    expect(find.text(l10nEn.logoutConfirmTitle), findsOneWidget);

    await tester.tap(find.text(l10nEn.cancel));
    await tester.pumpAndSettle();
    verifyNever(() => authBloc.add(any()));

    await tester.tap(find.byKey(const Key('settings_logout')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, l10nEn.logout));
    await tester.pumpAndSettle();
    verify(() => authBloc.add(const AuthLogoutRequested())).called(1);
  });
}
