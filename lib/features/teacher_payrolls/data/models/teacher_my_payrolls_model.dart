import 'payroll_parsing.dart';
import 'teacher_payroll_model.dart';

class TeacherPayrollCurrencySummaryModel {
  const TeacherPayrollCurrencySummaryModel({
    required this.currency,
    required this.draftAmount,
    required this.paidAmount,
    required this.totalAmount,
    required this.payrollsCount,
  });
  final String currency;
  final double draftAmount, paidAmount, totalAmount;
  final int payrollsCount;

  factory TeacherPayrollCurrencySummaryModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return TeacherPayrollCurrencySummaryModel(
      currency: payrollString(json['currency']),
      draftAmount: payrollDouble(json['draftAmount']),
      paidAmount: payrollDouble(json['paidAmount']),
      totalAmount: payrollDouble(json['totalAmount']),
      payrollsCount: payrollInt(json['payrollsCount']),
    );
  }
}

class TeacherMyPayrollsModel {
  const TeacherMyPayrollsModel({required this.summary, required this.payrolls});
  final List<TeacherPayrollCurrencySummaryModel> summary;
  final List<TeacherPayrollModel> payrolls;

  factory TeacherMyPayrollsModel.fromResponse(Object? response) {
    final json = payrollData(response);
    return TeacherMyPayrollsModel(
      summary: payrollList(
        json['summary'],
      ).map(TeacherPayrollCurrencySummaryModel.fromJson).toList(),
      payrolls: payrollList(
        json['payrolls'],
      ).map(TeacherPayrollModel.fromResponse).toList(),
    );
  }
}
