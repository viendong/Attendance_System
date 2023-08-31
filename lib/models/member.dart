import 'dart:convert';

class Member {
  Member({
    required this.name,
    required this.email,
    this.modelData,
    this.id = 0,
    this.role = "",
  });

  final int id;
  final String name;
  final String email;
  String? role;
  List? modelData;

  factory Member.fromJson(Map<String, dynamic> json) {
    if (json['data'] is String && json['data'] == "") {
      return Member(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        modelData: [],
      );
    }
    return Member(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      modelData: jsonDecode(json['data']) as List?,
      role: json['role'] as String,
    );
  }
}
