class Report {
  Report({
    required this.link,
    required this.check_in_date,
  });

  final String link;
  final DateTime check_in_date;

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      link: json['link'] as String,
      check_in_date: DateTime.parse(json['check_in_date'] as String),
    );
  }
}
