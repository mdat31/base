import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../requests/login/login_request.dart';
import '../responses/login/login_response.dart';

// Project imports:

part 'authentication_api.g.dart';

@RestApi()
abstract class AuthenticationApi {
  factory AuthenticationApi(Dio dio, {String baseUrl}) = _AuthenticationApi;

  @POST('/login')
  Future<LoginResponse> login(@Body() LoginRequest request);
}
