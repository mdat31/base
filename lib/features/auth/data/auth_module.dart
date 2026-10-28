import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/di/di_keys.dart';
import 'package:mod/features/auth/data/api/auth_api.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthApi authApi(Dio dio) => AuthApi(dio);

  @Named(DiKeys.plainDio)
  @lazySingleton
  AuthApi plainAuthApi(@Named(DiKeys.plainDio) Dio dio) => AuthApi(dio);
}
