import 'payroll_parsing.dart';

class PayrollWorkItemModel {
  const PayrollWorkItemModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.system,
    required this.minutes,
    required this.displayDuration,
    required this.sessionsCount,
    required this.rate,
    required this.amount,
  });
  final String curriculumId, curriculumName, system, displayDuration;
  final int minutes, sessionsCount;
  final double rate, amount;

  factory PayrollWorkItemModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollWorkItemModel(
      curriculumId: payrollString(json['curriculumId']),
      curriculumName: payrollString(json['curriculumName']),
      system: payrollString(json['system']),
      minutes: payrollInt(json['minutes']),
      displayDuration: payrollString(json['displayDuration']),
      sessionsCount: payrollInt(json['sessionsCount']),
      rate: payrollDouble(json['rate']),
      amount: payrollDouble(json['amount']),
    );
  }
}
