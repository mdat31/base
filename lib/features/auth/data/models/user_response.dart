import 'package:json_annotation/json_annotation.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';

part 'user_response.g.dart';

@JsonSerializable(createToJson: false)
class UserResponse {
  const UserResponse({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;

  UserEntity toEntity() => UserEntity(
    id: id,
    username: username,
    email: email ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    avatarUrl: image,
  );
}
