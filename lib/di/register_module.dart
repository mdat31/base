import 'package:base/data/remote/interceptors/auth_interceptors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  Connectivity get connectivity => Connectivity();

  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  Dio get dio => Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ))
        ..interceptors.addAll([
          AuthInterceptors(),

          /// Log must always be at the end of list
          LogInterceptor(
            request: false,
            responseHeader: false,
            responseBody: true,
            requestBody: true,
          ),
        ]);
}
