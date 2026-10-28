import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/di/di_keys.dart';
import 'package:mod/core/network/dio_factory.dart';
import 'package:mod/core/network/interceptors/auth_interceptor.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';
import 'package:mod/core/network/token_refresher.dart';
import 'package:mod/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Third-party types that cannot be annotated directly.
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @Named(DiKeys.plainDio)
  @lazySingleton
  Dio plainDio(AppConfig config) => DioFactory.create(config);

  @lazySingleton
  Dio dio(
    AppConfig config,
    TokenStorage tokenStorage,
    TokenRefresher tokenRefresher,
    SessionExpiryNotifier sessionExpiryNotifier,
    @Named(DiKeys.plainDio) Dio plainDio,
  ) => DioFactory.create(
    config,
    interceptors: [
      AuthInterceptor(
        tokenStorage: tokenStorage,
        tokenRefresher: tokenRefresher,
        sessionExpiryNotifier: sessionExpiryNotifier,
        retryClient: plainDio,
      ),
    ],
  );
}
