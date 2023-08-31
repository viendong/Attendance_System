import 'package:face_net_authentication/base/base_controller.dart';
import 'package:face_net_authentication/http/class.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/pages/student/student_binding.dart';
import 'package:face_net_authentication/state/user.dart';

class StudentController extends BaseController {
  StudentController();
  static StudentController _instance = StudentController();
  static StudentController get instance => _instance;

  ClassHttp _studentHttp = ClassHttp();
  UserState _userState = locator<UserState>();

  void _initializeServices() async {
    loading.value = true;

    loading.value = false;
  }

  void dispose() {
    StudentBinding().dispose();
  }

  Future<List<Class>?> getClasses() async {
    final data = await _studentHttp.getClasses(_userState.currentMember!.id);
    return data;
  }
}
