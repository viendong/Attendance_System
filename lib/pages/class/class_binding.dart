import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/class/class_controller.dart';

class ClassBinding extends BaseBinding {
  @override
  void dependencies() {
    if (!locator.isRegistered<ClassController>()) {
      locator.registerLazySingleton<ClassController>(() => ClassController());
    }
  }

  @override
  void dispose() {
    locator.unregister<ClassController>();
  }
}
