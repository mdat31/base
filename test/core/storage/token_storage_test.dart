import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/core/network/auth_tokens.dart';
import 'package:mod/core/storage/token_storage.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage secure;
  late SecureTokenStorage storage;

  const tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

  setUp(() {
    secure = _MockSecureStorage();
    storage = SecureTokenStorage(secure);
    when(
      () => secure.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => secure.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  });

  test('returns null when nothing is stored', () async {
    when(() => secure.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);

    expect(await storage.read(), isNull);
  });

  test('reads tokens from secure storage once, then from cache', () async {
    when(() => secure.read(key: SecureTokenStorage.accessTokenKey))
        .thenAnswer((_) async => 'a');
    when(() => secure.read(key: SecureTokenStorage.refreshTokenKey))
        .thenAnswer((_) async => 'r');

    expect(await storage.read(), tokens);
    expect(await storage.read(), tokens);
    verify(() => secure.read(key: SecureTokenStorage.accessTokenKey)).called(1);
  });

  test('save writes both keys and caches', () async {
    await storage.save(tokens);

    verify(
      () => secure.write(key: SecureTokenStorage.accessTokenKey, value: 'a'),
    ).called(1);
    verify(
      () => secure.write(key: SecureTokenStorage.refreshTokenKey, value: 'r'),
    ).called(1);
    expect(await storage.read(), tokens);
    verifyNever(() => secure.read(key: any(named: 'key')));
  });

  test('clear deletes both keys and the cache', () async {
    await storage.save(tokens);
    when(() => secure.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);

    await storage.clear();

    verify(() => secure.delete(key: SecureTokenStorage.accessTokenKey))
        .called(1);
    verify(() => secure.delete(key: SecureTokenStorage.refreshTokenKey))
        .called(1);
    expect(await storage.read(), isNull);
  });
}
