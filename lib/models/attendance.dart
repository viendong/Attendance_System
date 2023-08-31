class Attendance {
  Attendance({
    required this.id,
    required this.class_id,
    required this.status,
    required this.check_in_date,
  });

  final int id;
  final int class_id;
  final String status;
  final DateTime check_in_date;

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      class_id: json['class_id'] as int,
      status: json['status'] as String,
      check_in_date: DateTime.parse(json['check_in_date'] as String),
    );
  }
}
