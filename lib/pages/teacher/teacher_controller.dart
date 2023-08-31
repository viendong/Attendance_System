import 'package:face_net_authentication/base/base_controller.dart';
import 'package:face_net_authentication/http/class.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/pages/student/student_binding.dart';
import 'package:face_net_authentication/state/user.dart';

class TeacherController extends BaseController {
  TeacherController();
  static TeacherController _instance = TeacherController();
  static TeacherController get instance => _instance;

  ClassHttp _studentHttp = ClassHttp();
  UserState _userState = locator<UserState>();

  void _initializeServices() async {
    loading.value = true;

    loading.value = false;
  }

  Future<List<Class>?> getClasses() async {
    final data = await _studentHttp.getClasses(_userState.currentMember!.id);
    return data;
  }

  Future<Class?> createClass(String name, String desc) async {
    final data = await _studentHttp.createClass(
      name,
      desc,
      _userState.currentMember!.id,
    );
    return data;
  }

  void dispose() {
    StudentBinding().dispose();
  }
}
