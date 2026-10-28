import 'package:flutter_test/flutter_test.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/data/models/login_response.dart';
import 'package:mod/features/auth/data/models/refresh_token_request.dart';
import 'package:mod/features/auth/data/models/token_response.dart';
import 'package:mod/features/auth/data/models/user_response.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  test('LoginRequest serializes credentials', () {
    expect(const LoginRequest(username: 'u', password: 'p').toJson(), {
      'username': 'u',
      'password': 'p',
    });
  });

  test('RefreshTokenRequest serializes token', () {
    expect(const RefreshTokenRequest(refreshToken: 'r').toJson(), {
      'refreshToken': 'r',
    });
  });

  test('LoginResponse maps to entity and tokens', () {
    final response = LoginResponse.fromJson(tLoginJson);

    expect(response.toEntity(), tUser);
    expect(response.toTokens(), tTokens);
  });

  test('UserResponse tolerates missing optional fields', () {
    final entity = UserResponse.fromJson(const {'id': 2, 'username': 'bob'})
        .toEntity();

    expect(entity.email, isEmpty);
    expect(entity.avatarUrl, isNull);
    expect(entity.fullName, 'bob');
  });

  test('TokenResponse maps to tokens', () {
    expect(
      TokenResponse.fromJson(const {
        'accessToken': 'access',
        'refreshToken': 'refresh',
      }).toTokens(),
      tTokens,
    );
  });

  test('UserEntity.fullName joins first and last name', () {
    expect(tUser.fullName, 'Emily Johnson');
  });
}
