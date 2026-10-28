import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/network/auth_tokens.dart';
import 'package:mod/core/network/interceptors/auth_interceptor.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';
import 'package:mod/core/network/token_refresher.dart';
import 'package:mod/core/storage/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockTokenRefresher extends Mock implements TokenRefresher {}

class _MockSessionExpiryNotifier extends Mock
    implements SessionExpiryNotifier {}

class _MockDio extends Mock implements Dio {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  const oldTokens = AuthTokens(accessToken: 'old', refreshToken: 'r1');
  const newTokens = AuthTokens(accessToken: 'new', refreshToken: 'r2');

  late _MockTokenStorage storage;
  late _MockTokenRefresher refresher;
  late _MockSessionExpiryNotifier notifier;
  late _MockDio retryClient;
  late AuthInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
    registerFallbackValue(oldTokens);
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(Response<dynamic>(requestOptions: RequestOptions()));
  });

  setUp(() {
    storage = _MockTokenStorage();
    refresher = _MockTokenRefresher();
    notifier = _MockSessionExpiryNotifier();
    retryClient = _MockDio();
    interceptor = AuthInterceptor(
      tokenStorage: storage,
      tokenRefresher: refresher,
      sessionExpiryNotifier: notifier,
      retryClient: retryClient,
    );
    when(() => storage.save(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
  });

  group('onRequest', () {
    test('adds bearer token when a session exists', () async {
      when(() => storage.read()).thenAnswer((_) async => oldTokens);
      final options = RequestOptions(path: '/me');
      final handler = _MockRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers[HttpHeaders.authorizationHeader], 'Bearer old');
      verify(() => handler.next(options)).called(1);
    });

    test('skips auth when requested', () async {
      final options = RequestOptions(
        path: '/login',
        extra: {AuthInterceptor.skipAuthKey: true},
      );
      final handler = _MockRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(
        options.headers.containsKey(HttpHeaders.authorizationHeader),
        isFalse,
      );
      verifyNever(() => storage.read());
      verify(() => handler.next(options)).called(1);
    });

    test('leaves headers untouched without a session', () async {
      when(() => storage.read()).thenAnswer((_) async => null);
      final options = RequestOptions(path: '/me');

      await interceptor.onRequest(options, _MockRequestHandler());

      expect(
        options.headers.containsKey(HttpHeaders.authorizationHeader),
        isFalse,
      );
    });
  });

  group('onError', () {
    DioException unauthorized({Map<String, dynamic>? extra}) {
      final options = RequestOptions(
        path: '/me',
        headers: {HttpHeaders.authorizationHeader: 'Bearer old'},
        extra: extra,
      );
      return DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(requestOptions: options, statusCode: 401),
      );
    }

    test('passes through non-401 errors', () async {
      final err = DioException(
        requestOptions: RequestOptions(),
        response: Response<dynamic>(
          requestOptions: RequestOptions(),
          statusCode: 500,
        ),
      );
      final handler = _MockErrorHandler();

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => refresher.refresh(any()));
    });

    test('passes through when there is no session', () async {
      when(() => storage.read()).thenAnswer((_) async => null);
      final err = unauthorized();
      final handler = _MockErrorHandler();

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
    });

    test('refreshes, saves and retries on 401', () async {
      when(() => storage.read()).thenAnswer((_) async => oldTokens);
      when(() => refresher.refresh('r1')).thenAnswer((_) async => newTokens);
      final retried = Response<dynamic>(
        requestOptions: RequestOptions(),
        statusCode: 200,
      );
      when(() => retryClient.fetch<dynamic>(any()))
          .thenAnswer((_) async => retried);
      final err = unauthorized();
      final handler = _MockErrorHandler();

      await interceptor.onError(err, handler);

      verify(() => storage.save(newTokens)).called(1);
      final sent =
          verify(() => retryClient.fetch<dynamic>(captureAny())).captured.single
              as RequestOptions;
      expect(sent.headers[HttpHeaders.authorizationHeader], 'Bearer new');
      verify(() => handler.resolve(retried)).called(1);
    });

    test('reuses a token refreshed by a previous queued request', () async {
      when(() => storage.read()).thenAnswer((_) async => newTokens);
      when(() => retryClient.fetch<dynamic>(any())).thenAnswer(
        (_) async => Response<dynamic>(requestOptions: RequestOptions()),
      );

      await interceptor.onError(unauthorized(), _MockErrorHandler());

      verifyNever(() => refresher.refresh(any()));
      verify(() => retryClient.fetch<dynamic>(any())).called(1);
    });

    test('clears session and notifies when refresh fails', () async {
      when(() => storage.read()).thenAnswer((_) async => oldTokens);
      when(() => refresher.refresh(any())).thenThrow(Exception('expired'));
      final err = unauthorized();
      final handler = _MockErrorHandler();

      await interceptor.onError(err, handler);

      verify(() => storage.clear()).called(1);
      verify(() => notifier.notifyExpired()).called(1);
      verify(() => handler.next(err)).called(1);
    });

    test('does not retry twice', () async {
      final err = unauthorized(extra: {'authRetried': true});
      final handler = _MockErrorHandler();

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => storage.read());
    });
  });
}
