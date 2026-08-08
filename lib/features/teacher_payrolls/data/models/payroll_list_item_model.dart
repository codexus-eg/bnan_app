import 'payroll_parsing.dart';

class PayrollListItemModel {
  const PayrollListItemModel({
    required this.teacherId,
    required this.fullName,
    required this.email,
    required this.status,
    required this.payrollId,
    required this.gulfDuration,
    required this.egyptianSessions,
    required this.curriculumsCount,
    required this.excludedSessions,
  });
  final String teacherId, fullName, email, status, payrollId, gulfDuration;
  final int egyptianSessions, curriculumsCount, excludedSessions;

  factory PayrollListItemModel.fromJson(Object? value) {
    final json = payrollMap(value);
    final gulf = payrollMap(json['gulf']);
    final egyptian = payrollMap(json['egyptian']);
    return PayrollListItemModel(
      teacherId: payrollString(json['teacherId']),
      fullName: payrollString(json['fullName']),
      email: payrollString(json['email']),
      status: payrollString(json['payrollStatus'] ?? json['status']),
      payrollId: payrollString(json['payrollId']),
      gulfDuration: payrollString(gulf['displayDuration']),
      egyptianSessions: payrollInt(egyptian['sessionsCount']),
      curriculumsCount: payrollInt(json['curriculumsCount']),
      excludedSessions: payrollInt(json['excludedSessionsCount']),
    );
  }
}
