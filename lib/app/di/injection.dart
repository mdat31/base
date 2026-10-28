import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/app/di/injection.config.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/logging/app_logger.dart';

/// Service locator. Only the composition root (`lib/app`, `bootstrap`) may
/// read from it; features receive dependencies through constructors.
final GetIt getIt = GetIt.instance;

@InjectableInit(ignoreUnregisteredTypes: [AppConfig, AppLogger])
Future<GetIt> configureDependencies({
  required AppConfig config,
  required AppLogger logger,
}) async {
  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<AppLogger>(logger);
  return getIt.init();
}
