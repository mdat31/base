import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

/// Thin logging facade. Swap the sink (Crashlytics, Sentry, ...) here without
/// touching callers.
class AppLogger {
  const AppLogger({required this.enabled, this.name = 'mod'});

  final bool enabled;
  final String name;

  void debug(String message) => _log(LogLevel.debug, message);

  void info(String message) => _log(LogLevel.info, message);

  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);

  /// Errors are always recorded, even when verbose logging is off.
  void error(String message, [Object? error, StackTrace? stackTrace]) => _log(
    LogLevel.error,
    message,
    error: error,
    stackTrace: stackTrace,
    force: true,
  );

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool force = false,
  }) {
    if (!enabled && !force) return;
    developer.log(
      '[${level.name.toUpperCase()}] $message',
      name: name,
      level: switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      },
      error: error,
      stackTrace: stackTrace,
    );
  }
}
