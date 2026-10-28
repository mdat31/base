import 'package:json_annotation/json_annotation.dart';
import 'package:mod/core/network/auth_tokens.dart';
import 'package:mod/features/auth/data/models/user_response.dart';

part 'login_response.g.dart';

/// Login returns the user and the token pair in one flat object.
@JsonSerializable(createToJson: false)
class LoginResponse extends UserResponse {
  const LoginResponse({
    required super.id,
    required super.username,
    required this.accessToken,
    required this.refreshToken,
    super.email,
    super.firstName,
    super.lastName,
    super.image,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  final String accessToken;
  final String refreshToken;

  AuthTokens toTokens() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
