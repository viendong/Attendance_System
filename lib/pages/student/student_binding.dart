import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/student/student_controller.dart';

class StudentBinding extends BaseBinding {
  @override
  void dependencies() {
    if (!locator.isRegistered<StudentController>()) {
      locator
          .registerLazySingleton<StudentController>(() => StudentController());
    }
  }

  @override
  void dispose() {
    locator.unregister<StudentController>();
  }
}
