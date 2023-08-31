import 'dart:convert';

import 'package:face_net_authentication/config.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/member.dart';
import 'package:http/http.dart' as http;

class MemberHttp {
  Config config = locator<Config>();

  Future<Member?> sign(
    String email,
    String? name,
  ) async {
    final Uri url = Uri.parse(Constants().getBaseURL() + '/members/sign');
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data), // Encode your data as JSON
    );

    return Member.fromJson(jsonDecode(response.body));
  }

  Future<Member> Update(Member member) async {
    final Uri url = Uri.parse(
        Constants().getBaseURL() + '/members/' + member.id.toString());
    final Map<String, dynamic> data = {
      'email': member.email,
      'name': member.name,
      'data': jsonEncode(member.modelData),
      'role': member.role,
    };

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data), // Encode your data as JSON
    );

    return Member.fromJson(jsonDecode(response.body));
  }

  Future<Member> invite(
    String email,
    String name,
    int classId,
  ) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classId.toString() +
        '/members');

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data), // Encode your data as JSON
    );

    return Member.fromJson(jsonDecode(response.body));
  }

  Future<List<Member>> getStudents(int classId) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classId.toString() +
        '/members');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> json = jsonDecode(response.body);
    List<Member> members =
        json["members"].map<Member>((json) => Member.fromJson(json)).toList();

    return members;
  }

  Future<void> deleteStudent(int classID, int memberId) async {
    final Uri url = Uri.parse(Constants().getBaseURL() +
        '/classes/' +
        classID.toString() +
        '/members/' +
        memberId.toString());

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student.');
    }
  }

  Future<bool> checkin(String email, List data) async {
    final Uri url = Uri.parse(Constants().getBaseURL() + '/members/predict');
    final Map<String, dynamic> req = {
      'email': email,
      'data': jsonEncode(data),
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(req), // Encode your data as JSON
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
