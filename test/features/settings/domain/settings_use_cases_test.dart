import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';
import 'package:mod/features/settings/domain/repositories/settings_repository.dart';
import 'package:mod/features/settings/domain/usecases/get_settings_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_language_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_theme_use_case.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;

  setUp(() => repository = _MockSettingsRepository());

  test('GetSettingsUseCase returns stored settings', () {
    const settings = AppSettings(themePreference: ThemePreference.dark);
    when(() => repository.getSettings()).thenReturn(settings);

    expect(GetSettingsUseCase(repository)(), settings);
  });

  test('UpdateThemeUseCase persists the preference', () async {
    when(() => repository.saveThemePreference(ThemePreference.light))
        .thenAnswer((_) async => const Right(unit));

    final result = await UpdateThemeUseCase(repository)(ThemePreference.light);

    expect(result.isRight(), isTrue);
  });

  test('UpdateLanguageUseCase persists the code', () async {
    when(() => repository.saveLanguageCode('ja'))
        .thenAnswer((_) async => const Right(unit));

    final result = await UpdateLanguageUseCase(repository)('ja');

    expect(result.isRight(), isTrue);
  });
}
