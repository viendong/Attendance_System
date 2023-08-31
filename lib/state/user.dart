import 'package:face_net_authentication/models/member.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {
  UserState();

  static final _state = UserState();

  static UserState get instance => _state;

  UserCredential? userCredentialEntity;
  UserCredential get userCredential => userCredentialEntity!;

  late Member? currentMember;

  void setUserCredential(UserCredential userCredential) {
    userCredentialEntity = userCredential;
  }
}
