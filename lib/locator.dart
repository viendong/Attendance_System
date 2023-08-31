import 'package:face_net_authentication/client/firebase_core.dart';
import 'package:face_net_authentication/config.dart';
import 'package:face_net_authentication/pages/class/class_binding.dart';
import 'package:face_net_authentication/pages/student/student_binding.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:face_net_authentication/state/user.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton(FirebaseCoreRepository());
  locator.registerLazySingleton<UserState>(() => UserState());
  locator.registerLazySingleton<ScreenRouter>(() => ScreenRouter());
  locator.registerLazySingleton(() => Config());
  StudentBinding().dependencies();
  ClassBinding().dependencies();
}
