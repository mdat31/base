import 'package:mod/core/error/result.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';

abstract interface class SettingsRepository {
  /// Synchronous so the first frame already uses the saved theme/locale.
  AppSettings getSettings();

  FutureResult<Unit> saveThemePreference(ThemePreference preference);

  FutureResult<Unit> saveLanguageCode(String? languageCode);
}
