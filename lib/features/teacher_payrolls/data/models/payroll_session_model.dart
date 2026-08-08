import 'payroll_parsing.dart';

class PayrollSessionModel {
  const PayrollSessionModel({
    required this.title,
    required this.date,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.status,
    required this.included,
  });
  final String title, date, startedAt, endedAt, status;
  final int durationMinutes;
  final bool included;
  factory PayrollSessionModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollSessionModel(
      title: payrollString(json['title']),
      date: payrollString(json['date']),
      startedAt: payrollString(json['actualStartedAt']),
      endedAt: payrollString(json['actualEndedAt']),
      durationMinutes: payrollInt(json['durationMinutes']),
      status: payrollString(json['status']),
      included: json['included'] == true,
    );
  }
}
