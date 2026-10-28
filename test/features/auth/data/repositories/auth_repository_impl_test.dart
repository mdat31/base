import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';
import 'package:mod/core/storage/token_storage.dart';
import 'package:mod/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/data/models/login_response.dart';
import 'package:mod/features/auth/data/models/user_response.dart';
import 'package:mod/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';

import '../../../../helpers/fixtures.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockSessionExpiryNotifier extends Mock
    implements SessionExpiryNotifier {}

void main() {
  late _MockRemote remote;
  late _MockTokenStorage storage;
  late _MockSessionExpiryNotifier notifier;
  late StreamController<void> expiry;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const LoginRequest(username: '', password: ''));
    registerFallbackValue(tTokens);
  });

  setUp(() {
    remote = _MockRemote();
    storage = _MockTokenStorage();
    notifier = _MockSessionExpiryNotifier();
    expiry = StreamController<void>.broadcast();
    when(() => notifier.onExpired).thenAnswer((_) => expiry.stream);
    when(() => storage.save(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    repository = AuthRepositoryImpl(remote, storage, notifier);
  });

  tearDown(() async {
    await repository.dispose();
    await expiry.close();
  });

  group('watchStatus', () {
    test('starts unauthenticated without tokens', () async {
      when(() => storage.read()).thenAnswer((_) async => null);

      expect(await repository.watchStatus().first, AuthStatus.unauthenticated);
    });

    test('starts authenticated with tokens, then follows changes', () async {
      when(() => storage.read()).thenAnswer((_) async => tTokens);

      final statuses = <AuthStatus>[];
      final subscription = repository.watchStatus().listen(statuses.add);
      await pumpEventQueue();

      expiry.add(null);
      await repository.logout();
      await pumpEventQueue();

      expect(statuses, [
        AuthStatus.authenticated,
        AuthStatus.unauthenticated,
        AuthStatus.unauthenticated,
      ]);
      await subscription.cancel();
    });
  });

  group('login', () {
    test('saves tokens, emits authenticated and returns user', () async {
      when(() => storage.read()).thenAnswer((_) async => null);
      when(() => remote.login(any()))
          .thenAnswer((_) async => LoginResponse.fromJson(tLoginJson));
      final statuses = <AuthStatus>[];
      final subscription = repository.watchStatus().listen(statuses.add);
      await pumpEventQueue();

      final result = await repository.login(username: 'u', password: 'p');
      await pumpEventQueue();

      expect(result.toNullable(), tUser);
      verify(() => storage.save(tTokens)).called(1);
      expect(statuses.last, AuthStatus.authenticated);
      await subscription.cancel();
    });

    test('returns failure when the API rejects', () async {
      when(() => remote.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: RequestOptions(),
            statusCode: 400,
            data: {'message': 'Invalid credentials'},
          ),
        ),
      );

      final result = await repository.login(username: 'u', password: 'p');

      expect(
        result.getLeft().toNullable(),
        const Failure.server(message: 'Invalid credentials', statusCode: 400),
      );
      verifyNever(() => storage.save(any()));
    });
  });

  test('logout clears tokens', () async {
    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    verify(() => storage.clear()).called(1);
  });

  group('getCurrentUser', () {
    test('returns mapped user', () async {
      when(() => remote.getCurrentUser())
          .thenAnswer((_) async => UserResponse.fromJson(tUserJson));

      expect((await repository.getCurrentUser()).toNullable(), tUser);
    });

    test('returns failure on network error', () async {
      when(() => remote.getCurrentUser()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        (await repository.getCurrentUser()).getLeft().toNullable(),
        isA<NetworkFailure>(),
      );
    });
  });
}
