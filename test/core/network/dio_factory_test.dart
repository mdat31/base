import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/network/dio_factory.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

void main() {
  AppConfig config({required bool logging}) => AppConfig.fromMap({
    'BASE_URL': 'https://api.example.com',
    'ENABLE_LOGGING': '$logging',
    'CONNECT_TIMEOUT_MS': '1000',
  });

  test('applies base options and interceptors', () {
    final interceptor = InterceptorsWrapper();
    final dio = DioFactory.create(
      config(logging: false),
      interceptors: [interceptor],
    );

    expect(dio.options.baseUrl, 'https://api.example.com');
    expect(dio.options.connectTimeout, const Duration(seconds: 1));
    expect(dio.interceptors, contains(interceptor));
    expect(dio.interceptors.whereType<PrettyDioLogger>(), isEmpty);
  });

  test('adds logger only when logging is enabled', () {
    final dio = DioFactory.create(config(logging: true));

    expect(dio.interceptors.whereType<PrettyDioLogger>(), hasLength(1));
  });
}
