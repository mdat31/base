import 'package:injectable/injectable.dart';
import 'package:mod/core/di/di_keys.dart';
import 'package:mod/core/network/auth_tokens.dart';
import 'package:mod/core/network/token_refresher.dart';
import 'package:mod/features/auth/data/api/auth_api.dart';
import 'package:mod/features/auth/data/models/refresh_token_request.dart';

/// Uses an [AuthApi] backed by the plain Dio so refreshing never recurses
/// through the auth interceptor.
@LazySingleton(as: TokenRefresher)
class AuthTokenRefresher implements TokenRefresher {
  const AuthTokenRefresher(@Named(DiKeys.plainDio) this._api);

  final AuthApi _api;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _api.refresh(
      RefreshTokenRequest(refreshToken: refreshToken),
    );
    return response.toTokens();
  }
}
