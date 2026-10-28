import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/features/auth/data/api/auth_api.dart';
import 'package:mod/features/auth/data/models/refresh_token_request.dart';
import 'package:mod/features/auth/data/models/token_response.dart';
import 'package:mod/features/auth/data/services/auth_token_refresher.dart';

import '../../../../helpers/fixtures.dart';

class _MockAuthApi extends Mock implements AuthApi {}

void main() {
  setUpAll(
    () => registerFallbackValue(const RefreshTokenRequest(refreshToken: '')),
  );

  test('exchanges refresh token for new tokens', () async {
    final api = _MockAuthApi();
    when(() => api.refresh(any())).thenAnswer(
      (_) async =>
          const TokenResponse(accessToken: 'access', refreshToken: 'refresh'),
    );

    final tokens = await AuthTokenRefresher(api).refresh('old');

    expect(tokens, tTokens);
    final request =
        verify(() => api.refresh(captureAny())).captured.single
            as RefreshTokenRequest;
    expect(request.refreshToken, 'old');
  });
}
