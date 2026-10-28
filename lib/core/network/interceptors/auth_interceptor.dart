import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';
import 'package:mod/core/network/token_refresher.dart';
import 'package:mod/core/storage/token_storage.dart';

/// Attaches the bearer token and transparently refreshes it once on 401.
///
/// A [QueuedInterceptor] processes errors one at a time, so concurrent 401s
/// trigger a single refresh. Mark public endpoints with
/// `@Extra({AuthInterceptor.skipAuthKey: true})`.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStorage,
    required this._tokenRefresher,
    required this._sessionExpiryNotifier,
    required this._retryClient,
  });

  static const skipAuthKey = 'skipAuth';
  static const _retriedKey = 'authRetried';

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;
  final SessionExpiryNotifier _sessionExpiryNotifier;
  final Dio _retryClient;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] != true) {
      final tokens = await _tokenStorage.read();
      if (tokens != null) {
        options.headers[HttpHeaders.authorizationHeader] =
            'Bearer ${tokens.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == HttpStatus.unauthorized &&
        options.extra[skipAuthKey] != true &&
        options.extra[_retriedKey] != true;
    if (!shouldRefresh) return handler.next(err);

    final current = await _tokenStorage.read();
    if (current == null) return handler.next(err);

    try {
      // Another queued request may already have refreshed the token.
      final sentToken = options.headers[HttpHeaders.authorizationHeader];
      var tokens = current;
      if (sentToken == 'Bearer ${current.accessToken}') {
        tokens = await _tokenRefresher.refresh(current.refreshToken);
        await _tokenStorage.save(tokens);
      }

      options
        ..extra[_retriedKey] = true
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${tokens.accessToken}';
      handler.resolve(await _retryClient.fetch<dynamic>(options));
    } on Object {
      await _tokenStorage.clear();
      _sessionExpiryNotifier.notifyExpired();
      handler.next(err);
    }
  }
}
