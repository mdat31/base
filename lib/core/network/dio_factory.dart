import 'package:dio/dio.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Builds [Dio] clients with shared options. Interceptors are passed in so
/// callers decide what each client needs (Open/Closed).
abstract final class DioFactory {
  static Dio create(
    AppConfig config, {
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );
    dio.interceptors.addAll(interceptors);
    if (config.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }
    return dio;
  }
}
