import 'package:mod/core/network/auth_tokens.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';

const tUser = UserEntity(
  id: 1,
  username: 'emilys',
  email: 'emily@example.com',
  firstName: 'Emily',
  lastName: 'Johnson',
  avatarUrl: 'https://example.com/emily.png',
);

const tTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');

const tUserJson = <String, dynamic>{
  'id': 1,
  'username': 'emilys',
  'email': 'emily@example.com',
  'firstName': 'Emily',
  'lastName': 'Johnson',
  'image': 'https://example.com/emily.png',
};

const tLoginJson = <String, dynamic>{
  ...tUserJson,
  'accessToken': 'access',
  'refreshToken': 'refresh',
};
