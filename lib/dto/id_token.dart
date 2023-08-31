import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IdTokenDto {
  IdTokenDto({
    required this.token,
    required this.expiredTime,
  });
  String token;
  DateTime expiredTime;
}
