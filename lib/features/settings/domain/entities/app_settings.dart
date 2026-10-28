import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemePreference.system) ThemePreference themePreference,

    /// `null` follows the device language.
    String? languageCode,
  }) = _AppSettings;
}
