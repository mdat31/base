import 'package:injectable/injectable.dart';
import 'package:mod/core/storage/key_value_storage.dart';

abstract interface class SettingsLocalDataSource {
  String? getThemePreference();
  Future<void> setThemePreference(String value);
  String? getLanguageCode();
  Future<void> setLanguageCode(String? value);
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._storage);

  static const themeKey = 'settings.theme';
  static const languageKey = 'settings.language';

  final KeyValueStorage _storage;

  @override
  String? getThemePreference() => _storage.getString(themeKey);

  @override
  Future<void> setThemePreference(String value) =>
      _storage.setString(themeKey, value);

  @override
  String? getLanguageCode() => _storage.getString(languageKey);

  @override
  Future<void> setLanguageCode(String? value) => value == null
      ? _storage.remove(languageKey)
      : _storage.setString(languageKey, value);
}
