import 'package:mod/core/network/auth_tokens.dart';

/// Exchanges a refresh token for a new token pair. Implemented by the auth
/// feature so core networking stays feature-agnostic.
abstract interface class TokenRefresher {
  Future<AuthTokens> refresh(String refreshToken);
}
