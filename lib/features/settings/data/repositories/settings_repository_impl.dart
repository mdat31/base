import 'package:injectable/injectable.dart';
import 'package:mod/core/error/exceptions.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/error/run_guarded.dart';
import 'package:mod/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';
import 'package:mod/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  AppSettings getSettings() {
    final storedTheme = _local.getThemePreference();
    return AppSettings(
      themePreference: ThemePreference.values.firstWhere(
        (preference) => preference.name == storedTheme,
        orElse: () => ThemePreference.system,
      ),
      languageCode: _local.getLanguageCode(),
    );
  }

  @override
  FutureResult<Unit> saveThemePreference(ThemePreference preference) =>
      _write(() => _local.setThemePreference(preference.name));

  @override
  FutureResult<Unit> saveLanguageCode(String? languageCode) =>
      _write(() => _local.setLanguageCode(languageCode));

  FutureResult<Unit> _write(Future<void> Function() write) =>
      runGuarded(() async {
        try {
          await write();
        } on Object catch (error) {
          throw CacheException('Failed to save settings', error);
        }
        return unit;
      });
}
