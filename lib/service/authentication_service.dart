import 'package:face_net_authentication/client/firebase/firebase_auth_repository.dart';
import 'package:face_net_authentication/dto/id_token_dto.dart';
import 'package:face_net_authentication/entity/user_credential_entity.dart';
import 'package:face_net_authentication/repository/auth_repository.dart';
import 'package:face_net_authentication/service/exceptions/auth_exception.dart';
import 'package:face_net_authentication/util/logger_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  AuthenticationService._();

  static final _instance = AuthenticationService._();

  static AuthenticationService get instance => _instance;

  final AuthRepository _authRepository = FirebaseAuthRepository();

  static IdTokenDto idNoneTenant = IdTokenDto(
    token: '',
  );

  static IdTokenDto idWithTenant = IdTokenDto(
    token: '',
  );

  static void resetIdToken() {
    // AuthenticationService.idNoneTenant = IdTokenDto(
    //   token: '',
    //   expiredTime: WorkspaceDateTime(1998),
    // );
    // AuthenticationService.idWithTenant = IdTokenDto(
    //   token: '',
    //   expiredTime: WorkspaceDateTime(1998),
    // );
  }

  Future<UserCredentialEntity> signInWithGoogle(
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
      logger.i(userCredentialEntity.idToken);
      AuthenticationService.idNoneTenant = IdTokenDto(
        token: userCredentialEntity.idToken,
        tenantId: '',
      );
      return userCredentialEntity;
    } catch (e) {
      logger.e(e);
      throw AuthSignInWithGoogleException();
    }
  }

  // Future<String> getIdToken({bool forceRenew = false}) async {
  //   final currentWorkspace = WorkspaceState.instance.currentWorkspace;

  //   if (currentWorkspace == null) {
  //     return await getIdTokenNoneTenant(forceRenew: forceRenew);
  //   }

  //   return await getIdTokenTenant(
  //     currentWorkspace.tenantId,
  //     customToken: currentWorkspace.customToken,
  //     refreshToken: currentWorkspace.refreshToken,
  //   );
  // }

  // Future<void> onSignOut() async {
  //   Get.offAllNamed<void>(
  //     EwDeviceScreen.NAME,
  //     predicate: (route) => Get.currentRoute == '/root',
  //   );

  //   await Future.wait([
  //     HiveSettingDeviceRepository().setLastActiveWorkspaceId(''),
  //     Get.find<EwPusherService>().disconnect(),
  //   ]);

  //   final bottomNavBarController = Get.find<EwBottomNavBarController>();
  //   bottomNavBarController.currentPageIndex.value = NavigationUtil.indexOf(
  //     EwScreen.home,
  //   );

  //   final responsive = ResponsiveState.instance;
  //   responsive.clearDialog();
  //   responsive.clearSubView();
  //   AlarmService.instance.clearAllAlarms();

  //   Future.delayed(const Duration(seconds: 2), () {
  //     StateUtil.clearAllState();
  //     AuthenticationService.resetIdToken();
  //   });
  // }
}
