import 'package:mod/core/config/flavor.dart';

/// Environment configuration injected at build time via
/// `--dart-define-from-file=config/<flavor>.json`.
///
/// Never put secrets here: dart-defines are readable from the binary.
final class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  /// Reads the compile-time values. `String.fromEnvironment` only works with
  /// `const`, so the keys are spelled out here and parsed by [fromMap].
  factory AppConfig.fromEnvironment() => AppConfig.fromMap(const {
    _flavorKey: String.fromEnvironment(_flavorKey),
    _appNameKey: String.fromEnvironment(_appNameKey),
    _baseUrlKey: String.fromEnvironment(_baseUrlKey),
    _enableLoggingKey: String.fromEnvironment(_enableLoggingKey),
    _connectTimeoutKey: String.fromEnvironment(_connectTimeoutKey),
    _receiveTimeoutKey: String.fromEnvironment(_receiveTimeoutKey),
  });

  factory AppConfig.fromMap(Map<String, String> values) {
    String? read(String key) {
      final value = values[key]?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final flavor = Flavor.fromName(read(_flavorKey));
    final baseUrl = read(_baseUrlKey);
    if (baseUrl == null) {
      throw StateError(
        'Missing $_baseUrlKey. Run with '
        '--dart-define-from-file=config/${flavor.name}.json',
      );
    }

    return AppConfig(
      flavor: flavor,
      appName: read(_appNameKey) ?? 'Mod',
      baseUrl: baseUrl,
      enableLogging:
          read(_enableLoggingKey)?.toLowerCase() == 'true' ||
          (read(_enableLoggingKey) == null && flavor != Flavor.prod),
      connectTimeout: _parseDuration(read(_connectTimeoutKey)),
      receiveTimeout: _parseDuration(read(_receiveTimeoutKey)),
    );
  }

  static const _flavorKey = 'FLAVOR';
  static const _appNameKey = 'APP_NAME';
  static const _baseUrlKey = 'BASE_URL';
  static const _enableLoggingKey = 'ENABLE_LOGGING';
  static const _connectTimeoutKey = 'CONNECT_TIMEOUT_MS';
  static const _receiveTimeoutKey = 'RECEIVE_TIMEOUT_MS';
  static const _defaultTimeout = Duration(seconds: 15);

  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isProd => flavor == Flavor.prod;

  static Duration _parseDuration(String? millis) {
    final value = int.tryParse(millis ?? '');
    return value == null || value <= 0
        ? _defaultTimeout
        : Duration(milliseconds: value);
  }
}
