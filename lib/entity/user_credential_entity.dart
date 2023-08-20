import 'package:face_net_authentication/constants.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserCredentialEntity {
  UserCredentialEntity({
    required this.id,
    required this.email,
    required this.idToken,
    required this.refreshToken,
    required this.name,
    this.signInMethod,
    this.photoUrl,
    this.workspaceId,
  });

  final String id;
  final String email;
  final String idToken;
  final String refreshToken;
  final String name;
  final String? photoUrl;
  final SignInMethod? signInMethod;
  final String? workspaceId;
}
