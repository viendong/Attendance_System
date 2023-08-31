import 'package:face_net_authentication/base/base_controller.dart';
import 'package:face_net_authentication/http/class.dart';
import 'package:face_net_authentication/http/member.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/models/member.dart';
import 'package:face_net_authentication/models/report.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:face_net_authentication/state/user.dart';

class ClassController extends BaseController {
  ClassController();
  static ClassController _instance = ClassController();
  static ClassController get instance => _instance;

  ScreenRouter screenRouter = locator<ScreenRouter>();

  MemberHttp memberHttp = MemberHttp();
  ClassHttp classHttp = ClassHttp();

  UserState userState = locator<UserState>();

  Future<Member> addStudent(
    String email,
    String name,
    int classId,
  ) async {
    try {
      final data = await memberHttp.invite(email, name, classId);
      return data;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Member>> getStudents(int classId) async {
    try {
      final data = await memberHttp.getStudents(classId);
      return data;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> deleteStudent(int classID, int memberId) async {
    try {
      await memberHttp.deleteStudent(classID, memberId);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<Class?> getClass(int classID) async {
    try {
      final data = await classHttp.getClass(classID);
      return data;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Report>> getReports(int classId) async {
    try {
      final data = await classHttp.getReports(classId);
      return data!;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
