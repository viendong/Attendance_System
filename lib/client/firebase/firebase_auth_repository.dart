import 'package:face_net_authentication/client/firebase/firebase_core_repository.dart';
import 'package:face_net_authentication/constants.dart';
import 'package:face_net_authentication/entity/user_credential_entity.dart';
import 'package:face_net_authentication/repository/auth_repository.dart';
import 'package:face_net_authentication/service/exceptions/auth_exception.dart';
import 'package:face_net_authentication/util/logger_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthRepository implements AuthRepository {
  factory FirebaseAuthRepository() {
    return _repo;
  }
  FirebaseAuthRepository._();
  static final _repo = FirebaseAuthRepository._();

  Future<FirebaseApp?> initialApp() async {
    return Firebase.initializeApp();
  }

  @override
  Future<UserCredentialEntity> signInWithOauth(
    OAuthCredential credential, {
    SignInMethod signInMethod = SignInMethod.googleId,
  }) async {
    try {
      final firebaseAuth = FirebaseAuth.instanceFor(
        app: FirebaseCoreRepository.app,
      );

      UserCredential newCredential;

      newCredential = await firebaseAuth.signInWithCredential(credential);

      final idToken = (await newCredential.user?.getIdToken()) ?? '';
      final email = newCredential.user?.email ?? 'example@gmail.com';
      final photo = newCredential.user?.photoURL;
      final refreshToken = newCredential.user?.refreshToken ?? '';

      String name = '';
      String newName = '';

      if (newCredential.user?.displayName == null) {
        name = newName;
      } else {
        if (newCredential.user?.displayName != newName && newName.isNotEmpty) {
          name = newName;
        } else {
          name = newCredential.user?.displayName ?? '';
        }
      }

      if (name.isNotEmpty) {
        await firebaseAuth.currentUser!.updateDisplayName(name);
      }

      return UserCredentialEntity(
        id: newCredential.user?.uid ?? '',
        email: email,
        idToken: idToken,
        name: name,
        photoUrl: photo,
        signInMethod: signInMethod,
        refreshToken: refreshToken,
      );
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw AuthAccountIsExistException();
        case 'invalid-credential':
          throw AuthInvalidCredentialException();
        case 'user-disabled':
          throw AuthUserDisabledException();
        case 'user-not-found':
          throw AuthUserNotFoundException();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<String?> getCustomToken(String idToken, String workspaceId) {
    throw Exception('[Firebase Auth] getCustomToken unimplemented');
  }

  @override
  Future<String?> getIdToken() {
    final currentUser =
        FirebaseAuth.instanceFor(app: FirebaseCoreRepository.app).currentUser;
    logger.i(currentUser);
    return currentUser!.getIdToken();
  }
}
