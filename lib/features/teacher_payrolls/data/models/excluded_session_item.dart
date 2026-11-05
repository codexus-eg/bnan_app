import 'payroll_parsing.dart';

class ExcludedSessionItem {
  const ExcludedSessionItem({
    required this.title,
    required this.date,
    required this.time,
    required this.exclusionReason,
  });

  final String title;
  final String date;
  final String time;
  final String exclusionReason;

  factory ExcludedSessionItem.fromJson(Object? value) {
    final json = payrollMap(value);
    return ExcludedSessionItem(
      title: payrollString(
        json['title'] ??
            json['subjectName'] ??
            json['sessionTitle'] ??
            json['name'],
      ),
      date: payrollString(json['date'] ?? json['sessionDate']),
      time: payrollString(
        json['time'] ?? json['displayTime'] ?? json['sessionTime'],
      ),
      exclusionReason: payrollString(
        json['exclusionReason'] ??
            json['reason'] ??
            json['exclusionMessage'] ??
            json['message'],
      ),
    );
  }
}
