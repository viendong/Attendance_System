import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/member.dart';

class Class {
  Class({
    required this.name,
    required this.description,
    this.id = 0,
    this.students = const [],
    this.attendances = const [],
  });

  final int id;
  final String name;
  final String description;
  final List<Member>? students;
  final List<Attendance>? attendances;

  factory Class.fromJson(Map<String, dynamic> json) {
    List<Member> student = [];
    if (json["students"] == null) {
      student = [];
    } else {
      student = json["students"]
          .map<Member>((json) => Member.fromJson(json))
          .toList();
    }
    List<Attendance> attendances = [];
    if (json["attendances"] == null) {
      attendances = [];
    } else {
      attendances = json["attendances"]
          .map<Attendance>((json) => Attendance.fromJson(json))
          .toList();
    }
    return Class(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      students: student,
      attendances: attendances,
    );
  }
}
