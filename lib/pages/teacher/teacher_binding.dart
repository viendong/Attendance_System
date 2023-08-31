import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/teacher/teacher_controller.dart';

class TeacherBinding extends BaseBinding {
  @override
  void dependencies() {
    if (!locator.isRegistered<TeacherController>()) {
      locator
          .registerLazySingleton<TeacherController>(() => TeacherController());
    }
  }

  @override
  void dispose() {
    locator.unregister<TeacherController>();
  }
}
