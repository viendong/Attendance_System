import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/login/login_controller.dart';
import 'package:face_net_authentication/services/authentication_service.dart';

class LoginBinding extends BaseBinding {
  @override
  void dependencies() {
    if (!locator.isRegistered<LoginController>()) {
      locator.registerLazySingleton<LoginController>(() => LoginController());
    }
    if (!locator.isRegistered<AuthenticationService>()) {
      locator.registerLazySingleton<AuthenticationService>(
          () => AuthenticationService());
    }
  }

  @override
  void dispose() {
    locator.unregister<LoginController>();
    locator.unregister<AuthenticationService>();
  }
}
