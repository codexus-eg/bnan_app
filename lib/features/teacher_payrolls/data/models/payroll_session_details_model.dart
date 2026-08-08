import 'payroll_parsing.dart';
import 'payroll_session_model.dart';

class PayrollSessionDetailsModel {
  const PayrollSessionDetailsModel({
    required this.sessions,
    required this.sessionsCount,
    required this.totalMinutes,
    required this.displayDuration,
  });
  final List<PayrollSessionModel> sessions;
  final int sessionsCount, totalMinutes;
  final String displayDuration;
  factory PayrollSessionDetailsModel.fromResponse(Object? response) {
    final json = payrollData(response);
    final values = json['sessions'] ?? json['items'] ?? json['data'];
    final sessions = payrollList(
      values,
    ).map(PayrollSessionModel.fromJson).toList();
    return PayrollSessionDetailsModel(
      sessions: sessions,
      sessionsCount: payrollInt(json['sessionsCount'] ?? sessions.length),
      totalMinutes: payrollInt(json['totalMinutes']),
      displayDuration: payrollString(json['displayDuration']),
    );
  }
}
