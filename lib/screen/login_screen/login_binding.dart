import 'package:face_net_authentication/base/binding.dart';
import 'package:face_net_authentication/screen/login_screen/login_controller.dart';
import 'package:get/get.dart';

class LoginScreenBinding extends BaseBindings {
  @override
  void dependencies() {
    Get.put(LoginScreenController());
  }
}
