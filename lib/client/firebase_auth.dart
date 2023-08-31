import 'dart:io';

import 'package:face_net_authentication/client/firebase_core.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/repo/auth_repo.dart';
import 'package:face_net_authentication/utils/logger.dart';
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

  FirebaseCoreRepository _firebaseCore = locator<FirebaseCoreRepository>();

  @override
  Future<UserCredential> signInWithOauth(
    OAuthCredential credential, {
    SignInMethod signInMethod = SignInMethod.googleId,
  }) async {
    try {
      final firebaseAuth = FirebaseAuth.instanceFor(
        app: _firebaseCore.instance,
      );

      UserCredential newCredential;

      newCredential = await firebaseAuth.signInWithCredential(credential);

      // final idToken = (await newCredential.user?.getIdToken()) ?? '';
      // final email = newCredential.user?.email ?? 'example@gmail.com';
      // final photo = newCredential.user?.photoURL;
      // // final refreshToken = newCredential.user?.refreshToken ?? '';

      // String name = '';
      // String newName = '';

      // if (newCredential.user?.displayName == null) {
      //   name = newName;
      // } else {
      //   if (newCredential.user?.displayName != newName && newName.isNotEmpty) {
      //     name = newName;
      //   } else {
      //     name = newCredential.user?.displayName ?? '';
      //   }
      // }

      // if (name.isNotEmpty) {
      //   await firebaseAuth.currentUser!.updateDisplayName(name);
      // }

      return newCredential;
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<String?> getIdToken() {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }
}
