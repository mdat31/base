import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/app/di/injection.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/di/di_keys.dart';
import 'package:mod/core/logging/app_logger.dart';
import 'package:mod/core/network/interceptors/auth_interceptor.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:mod/features/home/presentation/cubit/home_cubit.dart';
import 'package:mod/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Smoke test for the generated DI graph: catches missing registrations and
/// compile errors in `injection.config.dart`.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies(
      config: AppConfig.fromMap(const {'BASE_URL': 'https://example.com'}),
      logger: const AppLogger(enabled: false),
    );
  });

  tearDownAll(getIt.reset);

  test('resolves every bloc and cubit', () {
    expect(getIt<AuthBloc>(), isA<AuthBloc>());
    expect(getIt<LoginCubit>(), isA<LoginCubit>());
    expect(getIt<HomeCubit>(), isA<HomeCubit>());
    expect(getIt<SettingsCubit>(), isA<SettingsCubit>());
  });

  test('only the main Dio carries the auth interceptor', () {
    final dio = getIt<Dio>();
    final plainDio = getIt<Dio>(instanceName: DiKeys.plainDio);

    expect(dio.options.baseUrl, 'https://example.com');
    expect(dio.interceptors.whereType<AuthInterceptor>(), hasLength(1));
    expect(plainDio.interceptors.whereType<AuthInterceptor>(), isEmpty);
  });
}
