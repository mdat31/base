import 'package:injectable/injectable.dart';
import 'package:mod/features/auth/data/api/auth_api.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/data/models/login_response.dart';
import 'package:mod/features/auth/data/models/user_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<UserResponse> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final AuthApi _api;

  @override
  Future<LoginResponse> login(LoginRequest request) => _api.login(request);

  @override
  Future<UserResponse> getCurrentUser() => _api.me();
}
