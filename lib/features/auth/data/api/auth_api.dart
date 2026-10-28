import 'package:dio/dio.dart';
import 'package:mod/core/network/interceptors/auth_interceptor.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/data/models/login_response.dart';
import 'package:mod/features/auth/data/models/refresh_token_request.dart';
import 'package:mod/features/auth/data/models/token_response.dart';
import 'package:mod/features/auth/data/models/user_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  @Extra({AuthInterceptor.skipAuthKey: true})
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/refresh')
  @Extra({AuthInterceptor.skipAuthKey: true})
  Future<TokenResponse> refresh(@Body() RefreshTokenRequest request);

  @GET('/auth/me')
  Future<UserResponse> me();
}
