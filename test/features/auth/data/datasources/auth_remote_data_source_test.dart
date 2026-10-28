import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mod/features/auth/data/api/auth_api.dart';
import 'package:mod/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mod/features/auth/data/models/login_request.dart';
import 'package:mod/features/auth/data/models/login_response.dart';
import 'package:mod/features/auth/data/models/user_response.dart';

import '../../../../helpers/fixtures.dart';

class _MockAuthApi extends Mock implements AuthApi {}

void main() {
  late _MockAuthApi api;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    api = _MockAuthApi();
    dataSource = AuthRemoteDataSourceImpl(api);
  });

  test('login delegates to the API', () async {
    const request = LoginRequest(username: 'u', password: 'p');
    final response = LoginResponse.fromJson(tLoginJson);
    when(() => api.login(request)).thenAnswer((_) async => response);

    expect(await dataSource.login(request), response);
  });

  test('getCurrentUser calls /auth/me', () async {
    final response = UserResponse.fromJson(tUserJson);
    when(() => api.me()).thenAnswer((_) async => response);

    expect(await dataSource.getCurrentUser(), response);
  });
}
