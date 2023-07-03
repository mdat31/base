import 'package:dio/dio.dart';

class AuthInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.baseUrl = ServerEnv.env.url;
    // options.headers["Authorization"] = "Bearer ${SessionUtils.getAccessToken}";
    super.onRequest(options, handler);
  }
}