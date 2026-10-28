import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

@JsonSerializable(createFactory: false)
class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
