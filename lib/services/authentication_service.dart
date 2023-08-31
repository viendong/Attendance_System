import 'package:face_net_authentication/client/firebase_auth.dart';
import 'package:face_net_authentication/repo/auth_repo.dart';
import 'package:face_net_authentication/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  AuthenticationService();

  static final _instance = AuthenticationService();

  static AuthenticationService get instance => _instance;

  final AuthRepository _authRepository = FirebaseAuthRepository();

  Future<UserCredential> signInWithGoogle(
    GoogleSignInAccount googleSignInAccount,
  ) async {
    try {
      final googleAccountAuthentication =
          await googleSignInAccount.authentication;

      final googleAccountCredential = GoogleAuthProvider.credential(
        accessToken: googleAccountAuthentication.accessToken,
        idToken: googleAccountAuthentication.idToken,
      );

      final userCredentialEntity =
          await _authRepository.signInWithOauth(googleAccountCredential);

      return userCredentialEntity;
    } catch (e) {
      logger.e(e);
      // throw AuthSignInWithGoogleException();
      rethrow;
    }
  }
}
