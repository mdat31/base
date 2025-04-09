import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/di/injection.config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

@injectableInit
Future<void> setupInjection() => getIt.init();

@module
abstract class RegisterModule {
  @Named('Timeout')
  Duration get timeout => const Duration(seconds: 10);

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio dio(
    @Named('BaseUrl') String url,
    @Named('Timeout') Duration timeout,
  ) {
    return Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: timeout,
        contentType: 'application/json',
      ),
    )..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
  }
}
