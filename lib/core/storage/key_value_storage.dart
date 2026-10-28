import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive key/value storage. Use [TokenStorage] for secrets.
abstract interface class KeyValueStorage {
  String? getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
}

@LazySingleton(as: KeyValueStorage)
class SharedPreferencesStorage implements KeyValueStorage {
  SharedPreferencesStorage(this._preferences);

  final SharedPreferences _preferences;

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}
