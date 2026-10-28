import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mod/app/di/injection.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/logging/app_bloc_observer.dart';
import 'package:mod/core/logging/app_logger.dart';

/// Initializes config, error handling and DI, then runs [builder]'s widget.
/// Add SDK init (Firebase, Crashlytics, ...) here.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final logger = AppLogger(enabled: config.enableLogging);

  FlutterError.onError = (details) {
    logger.error(details.exceptionAsString(), details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.error('Uncaught platform error', error, stackTrace);
    return true;
  };

  await configureDependencies(config: config, logger: logger);
  Bloc.observer = AppBlocObserver(logger);

  runApp(await builder());
}
