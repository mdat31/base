import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';
import 'package:mod/features/settings/domain/usecases/get_settings_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_language_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_theme_use_case.dart';
import 'package:mod/features/settings/presentation/cubit/settings_cubit.dart';

class _MockGetSettings extends Mock implements GetSettingsUseCase {}

class _MockUpdateTheme extends Mock implements UpdateThemeUseCase {}

class _MockUpdateLanguage extends Mock implements UpdateLanguageUseCase {}

void main() {
  late _MockGetSettings getSettings;
  late _MockUpdateTheme updateTheme;
  late _MockUpdateLanguage updateLanguage;

  setUpAll(() => registerFallbackValue(ThemePreference.system));

  setUp(() {
    getSettings = _MockGetSettings();
    updateTheme = _MockUpdateTheme();
    updateLanguage = _MockUpdateLanguage();
    when(() => getSettings()).thenReturn(const AppSettings());
  });

  SettingsCubit build() =>
      SettingsCubit(getSettings, updateTheme, updateLanguage);

  test('initial state comes from stored settings', () {
    when(() => getSettings()).thenReturn(
      const AppSettings(
        themePreference: ThemePreference.dark,
        languageCode: 'vi',
      ),
    );

    expect(
      build().state,
      const SettingsState(themeMode: ThemeMode.dark, locale: Locale('vi')),
    );
  });

  test('ThemeMode and ThemePreference convert both ways', () {
    for (final mode in ThemeMode.values) {
      expect(mode.toPreference().toThemeMode(), mode);
    }
  });

  blocTest<SettingsCubit, SettingsState>(
    'changes theme mode',
    setUp: () =>
        when(() => updateTheme(any()))
            .thenAnswer((_) async => const Right(unit)),
    build: build,
    act: (cubit) => cubit.changeThemeMode(ThemeMode.dark),
    expect: () => const [SettingsState(themeMode: ThemeMode.dark)],
    verify: (_) => verify(() => updateTheme(ThemePreference.dark)).called(1),
  );

  blocTest<SettingsCubit, SettingsState>(
    'rolls back theme when saving fails',
    setUp: () =>
        when(() => updateTheme(any()))
            .thenAnswer((_) async => const Left(Failure.cache())),
    build: build,
    act: (cubit) => cubit.changeThemeMode(ThemeMode.light),
    expect: () => const [
      SettingsState(themeMode: ThemeMode.light),
      SettingsState(),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'ignores unchanged theme',
    build: build,
    act: (cubit) => cubit.changeThemeMode(ThemeMode.system),
    expect: () => const <SettingsState>[],
  );

  blocTest<SettingsCubit, SettingsState>(
    'changes locale and resets to system',
    setUp: () =>
        when(() => updateLanguage(any()))
            .thenAnswer((_) async => const Right(unit)),
    build: build,
    act: (cubit) async {
      await cubit.changeLocale(const Locale('ja'));
      await cubit.changeLocale(null);
    },
    expect: () => const [SettingsState(locale: Locale('ja')), SettingsState()],
    verify: (_) {
      verify(() => updateLanguage('ja')).called(1);
      verify(() => updateLanguage(null)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'rolls back locale when saving fails',
    setUp: () =>
        when(() => updateLanguage(any()))
            .thenAnswer((_) async => const Left(Failure.cache())),
    build: build,
    act: (cubit) => cubit.changeLocale(const Locale('vi')),
    expect: () => const [SettingsState(locale: Locale('vi')), SettingsState()],
  );
}
