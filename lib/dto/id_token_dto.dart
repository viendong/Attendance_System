import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IdTokenDto {
  IdTokenDto({
    required this.token,
    this.tenantId,
    this.refreshToken,
  });

  String token;
  String? tenantId;
  String? refreshToken;
}
