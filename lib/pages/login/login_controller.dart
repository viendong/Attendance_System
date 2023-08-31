import 'dart:math';

import 'package:face_net_authentication/base/base_controller.dart';
import 'package:face_net_authentication/http/member.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/login/login_binding.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:face_net_authentication/services/authentication_service.dart';
import 'package:face_net_authentication/state/user.dart';
import 'package:face_net_authentication/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends BaseController {
  LoginController();
  static LoginController _instance = LoginController();
  static LoginController get instance => _instance;

  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  UserState userState = locator<UserState>();
  ScreenRouter screenRouter = locator<ScreenRouter>();
  MemberHttp memberHttp = MemberHttp();

  Rx<String> selectedOption = 'Student'.obs;

  @override
  Future<void> initService() async {
    super.initService();
    loading.value = true;
    loading.value = false;
  }

  Future<GoogleSignInAccount?> signInWithGoogle(BuildContext context) async {
    try {
      final googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final userCredential =
            await _authenticationService.signInWithGoogle(googleSignInAccount);
        logger.i(googleSignInAccount.email);
        userState.setUserCredential(userCredential);
        GoogleSignIn().signOut();
      }
      return googleSignInAccount;
    } catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<void> signWithBackend(GoogleSignInAccount googleSignInAccount) async {
    final data = await memberHttp.sign(
        googleSignInAccount.email, googleSignInAccount.displayName);

    userState.currentMember = data;
  }

  void updatMember() async {}

  void dispose() {
    LoginBinding().dispose();
  }
}
