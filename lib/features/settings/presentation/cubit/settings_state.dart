part of 'settings_cubit.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// `null` follows the device language.
    Locale? locale,
  }) = _SettingsState;

  factory SettingsState.fromSettings(AppSettings settings) => SettingsState(
    themeMode: settings.themePreference.toThemeMode(),
    locale: settings.languageCode == null
        ? null
        : Locale(settings.languageCode!),
  );
}

extension ThemePreferenceX on ThemePreference {
  ThemeMode toThemeMode() => switch (this) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };
}

extension ThemeModeX on ThemeMode {
  ThemePreference toPreference() => switch (this) {
    ThemeMode.system => ThemePreference.system,
    ThemeMode.light => ThemePreference.light,
    ThemeMode.dark => ThemePreference.dark,
  };
}
