import 'payroll_parsing.dart';

class PayrollTotalsModel {
  const PayrollTotalsModel({
    required this.gulfAmount,
    required this.egyptianAmount,
    required this.subtotal,
    required this.bonus,
    required this.deduction,
    required this.total,
  });
  final double gulfAmount, egyptianAmount, subtotal, bonus, deduction, total;

  factory PayrollTotalsModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollTotalsModel(
      gulfAmount: payrollDouble(json['gulfAmount']),
      egyptianAmount: payrollDouble(json['egyptianAmount']),
      subtotal: payrollDouble(json['subtotal']),
      bonus: payrollDouble(json['bonus']),
      deduction: payrollDouble(json['deduction']),
      total: payrollDouble(json['total']),
    );
  }
}
