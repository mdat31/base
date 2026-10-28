import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/config/flavor.dart';

void main() {
  group('Flavor.fromName', () {
    test('parses known names', () {
      expect(Flavor.fromName('stg'), Flavor.stg);
      expect(Flavor.fromName('prod'), Flavor.prod);
    });

    test('falls back to dev', () {
      expect(Flavor.fromName(null), Flavor.dev);
      expect(Flavor.fromName('unknown'), Flavor.dev);
    });
  });

  group('AppConfig.fromMap', () {
    test('reads every value', () {
      final config = AppConfig.fromMap(const {
        'FLAVOR': 'stg',
        'APP_NAME': 'Mod Stg',
        'BASE_URL': 'https://api.example.com',
        'ENABLE_LOGGING': 'false',
        'CONNECT_TIMEOUT_MS': '5000',
        'RECEIVE_TIMEOUT_MS': '7000',
      });

      expect(config.flavor, Flavor.stg);
      expect(config.appName, 'Mod Stg');
      expect(config.baseUrl, 'https://api.example.com');
      expect(config.enableLogging, isFalse);
      expect(config.connectTimeout, const Duration(seconds: 5));
      expect(config.receiveTimeout, const Duration(seconds: 7));
      expect(config.isProd, isFalse);
    });

    test('applies defaults for optional values', () {
      final config = AppConfig.fromMap(const {
        'BASE_URL': 'https://api.example.com',
        'CONNECT_TIMEOUT_MS': 'abc',
      });

      expect(config.flavor, Flavor.dev);
      expect(config.appName, 'Mod');
      expect(config.enableLogging, isTrue);
      expect(config.connectTimeout, const Duration(seconds: 15));
    });

    test('disables logging by default on prod', () {
      final config = AppConfig.fromMap(const {
        'FLAVOR': 'prod',
        'BASE_URL': 'https://api.example.com',
      });

      expect(config.isProd, isTrue);
      expect(config.enableLogging, isFalse);
    });

    test('throws when BASE_URL is missing', () {
      expect(
        () => AppConfig.fromMap(const {'FLAVOR': 'dev', 'BASE_URL': ' '}),
        throwsStateError,
      );
    });
  });
}
