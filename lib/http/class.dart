import 'dart:convert';

import 'package:face_net_authentication/config.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/class.dart';
import 'package:face_net_authentication/models/report.dart';
import 'package:http/http.dart' as http;

class ClassHttp {
  Config config = locator<Config>();

  Future<List<Class>?> getClasses(int member_id) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/members/' +
        member_id.toString() +
        '/classes');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Map<String, dynamic> json = jsonDecode(response.body);
    List<Class> classes =
        json["classes"].map<Class>((json) => Class.fromJson(json)).toList();
    return classes;
  }

  Future<Class?> createClass(String name, String desc, int teacher_id) async {
    final Map<String, dynamic> data = {
      'name': name,
      'description': desc,
      'teacher_id': teacher_id
    };
    final Uri url = Uri.parse(
        Constants().getBaseURL() + '/classes/members/' + teacher_id.toString());
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    return Class.fromJson(jsonDecode(response.body));
  }

  Future<Class?> getClass(int classID) async {
    final Uri url =
        Uri.parse(Constants().getBaseURL() + '/classes/' + classID.toString());
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return Class.fromJson(jsonDecode(response.body));
  }

  Future<Attendance?> createAttendance(int classID) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classID.toString() +
        '/attendances');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return Future.error("faill");
    }
  }

  Future<Attendance?> closeAttendance(int classID, int attendancesID) async {
    final Map<String, dynamic> data = {
      'status': 'close',
    };
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classID.toString() +
        '/attendances/' +
        attendancesID.toString());
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return Future.error("faill");
    }
  }

  Future<List<Report>?> getReports(int classID) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classID.toString() +
        '/reports');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Map<String, dynamic> json = jsonDecode(response.body);
    List<Report> reports =
        json["reports"].map<Report>((json) => Report.fromJson(json)).toList();
    return reports;
  }
}
