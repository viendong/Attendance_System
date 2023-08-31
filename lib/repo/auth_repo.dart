import 'package:face_net_authentication/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in user using Oauth Credential
  Future<UserCredential> signInWithOauth(
    OAuthCredential oauthCredential, {
    SignInMethod signInMethod = SignInMethod.googleId,
  });

  /// Get newest id token (without custom claims)
  Future<String?> getIdToken();
}
