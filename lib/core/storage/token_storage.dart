import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/network/auth_tokens.dart';

/// Persists auth tokens. Abstracted so tests and other platforms can swap it.
abstract interface class TokenStorage {
  Future<AuthTokens?> read();
  Future<void> save(AuthTokens tokens);
  Future<void> clear();
}

@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  // Cached in memory: the interceptor reads the token on every request.
  AuthTokens? _cache;

  @override
  Future<AuthTokens?> read() async {
    if (_cache != null) return _cache;
    final accessToken = await _storage.read(key: accessTokenKey);
    final refreshToken = await _storage.read(key: refreshTokenKey);
    if (accessToken == null || refreshToken == null) return null;
    return _cache = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    await _storage.write(key: accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: refreshTokenKey, value: tokens.refreshToken);
    _cache = tokens;
  }

  @override
  Future<void> clear() async {
    _cache = null;
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }
}
