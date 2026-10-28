import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/storage/key_value_storage.dart';
import 'package:mod/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mod/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';

class _MockKeyValueStorage extends Mock implements KeyValueStorage {}

class _MockLocalDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  group('SettingsLocalDataSourceImpl', () {
    late _MockKeyValueStorage storage;
    late SettingsLocalDataSourceImpl dataSource;

    setUp(() {
      storage = _MockKeyValueStorage();
      dataSource = SettingsLocalDataSourceImpl(storage);
      when(() => storage.setString(any(), any())).thenAnswer((_) async {});
      when(() => storage.remove(any())).thenAnswer((_) async {});
    });

    test('reads stored values', () {
      when(() => storage.getString(SettingsLocalDataSourceImpl.themeKey))
          .thenReturn('dark');
      when(() => storage.getString(SettingsLocalDataSourceImpl.languageKey))
          .thenReturn('vi');

      expect(dataSource.getThemePreference(), 'dark');
      expect(dataSource.getLanguageCode(), 'vi');
    });

    test('writes theme and language', () async {
      await dataSource.setThemePreference('light');
      await dataSource.setLanguageCode('ja');

      verify(
        () => storage.setString(SettingsLocalDataSourceImpl.themeKey, 'light'),
      ).called(1);
      verify(
        () => storage.setString(SettingsLocalDataSourceImpl.languageKey, 'ja'),
      ).called(1);
    });

    test('null language removes the key', () async {
      await dataSource.setLanguageCode(null);

      verify(() => storage.remove(SettingsLocalDataSourceImpl.languageKey))
          .called(1);
    });
  });

  group('SettingsRepositoryImpl', () {
    late _MockLocalDataSource local;
    late SettingsRepositoryImpl repository;

    setUp(() {
      local = _MockLocalDataSource();
      repository = SettingsRepositoryImpl(local);
    });

    test('maps stored values to AppSettings', () {
      when(() => local.getThemePreference()).thenReturn('dark');
      when(() => local.getLanguageCode()).thenReturn('vi');

      expect(
        repository.getSettings(),
        const AppSettings(
          themePreference: ThemePreference.dark,
          languageCode: 'vi',
        ),
      );
    });

    test('falls back to defaults for unknown values', () {
      when(() => local.getThemePreference()).thenReturn('neon');
      when(() => local.getLanguageCode()).thenReturn(null);

      expect(repository.getSettings(), const AppSettings());
    });

    test('saves theme preference by name', () async {
      when(() => local.setThemePreference(any())).thenAnswer((_) async {});

      final result = await repository.saveThemePreference(
        ThemePreference.light,
      );

      expect(result.isRight(), isTrue);
      verify(() => local.setThemePreference('light')).called(1);
    });

    test('maps write errors to CacheFailure', () async {
      when(() => local.setLanguageCode(any())).thenThrow(Exception('disk'));

      final result = await repository.saveLanguageCode('vi');

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });
}
