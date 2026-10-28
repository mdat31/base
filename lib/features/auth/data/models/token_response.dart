import 'package:json_annotation/json_annotation.dart';
import 'package:mod/core/network/auth_tokens.dart';

part 'token_response.g.dart';

@JsonSerializable(createToJson: false)
class TokenResponse {
  const TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  final String accessToken;
  final String refreshToken;

  AuthTokens toTokens() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
