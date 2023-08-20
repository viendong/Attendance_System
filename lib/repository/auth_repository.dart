import 'package:face_net_authentication/constants.dart';
import 'package:face_net_authentication/entity/user_credential_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in user using Oauth Credential
  Future<UserCredentialEntity> signInWithOauth(
    OAuthCredential oauthCredential, {
    SignInMethod signInMethod = SignInMethod.googleId,
  });

  Future<String?> getCustomToken(String idToken, String workspaceId);

  /// Get newest id token (without custom claims)
  Future<String?> getIdToken();
}
