import 'payroll_parsing.dart';

class PayrollWorkItemModel {
  const PayrollWorkItemModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.gradeId,
    required this.gradeName,
    required this.system,
    required this.rateType,
    required this.minutes,
    required this.displayDuration,
    required this.sessionsCount,
    required this.rate,
    required this.amount,
    required this.hasRate,
  });
  final String curriculumId, curriculumName, gradeId, gradeName;
  final String system, rateType, displayDuration;
  final int minutes, sessionsCount;
  final double rate, amount;
  final bool hasRate;

  factory PayrollWorkItemModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollWorkItemModel(
      curriculumId: payrollString(json['curriculumId']),
      curriculumName: payrollString(json['curriculumName']),
      gradeId: payrollString(json['gradeId']),
      gradeName: payrollString(json['gradeName']),
      system: payrollString(json['system']),
      rateType: payrollString(json['rateType']),
      minutes: payrollInt(json['minutes']),
      displayDuration: payrollString(json['displayDuration']),
      sessionsCount: payrollInt(json['sessionsCount']),
      rate: payrollDouble(json['rate']),
      amount: payrollDouble(json['amount']),
      hasRate: json['rate'] != null,
    );
  }
}
