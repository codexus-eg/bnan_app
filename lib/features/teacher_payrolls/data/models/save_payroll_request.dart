import 'payroll_period_model.dart';

class PayrollRateRequest {
  const PayrollRateRequest(this.gradeId, this.rate);
  final String gradeId;
  final double rate;
  Map<String, dynamic> toJson() => {'gradeId': gradeId, 'rate': rate};
}

class SavePayrollRequest {
  const SavePayrollRequest({
    this.teacherId,
    this.period,
    required this.currency,
    required this.rates,
    required this.bonus,
    required this.deduction,
    required this.adjustmentNote,
    required this.notes,
  });
  final String? teacherId;
  final PayrollPeriodModel? period;
  final String currency, adjustmentNote, notes;
  final List<PayrollRateRequest> rates;
  final double bonus, deduction;
  Map<String, dynamic> toJson() => {
    if (teacherId != null) 'teacherId': teacherId,
    if (period != null) 'period': period!.toJson(),
    'currency': currency,
    'rates': rates.map((e) => e.toJson()).toList(),
    'bonus': bonus,
    'deduction': deduction,
    if (adjustmentNote.trim().isNotEmpty)
      'adjustmentNote': adjustmentNote.trim(),
    if (notes.trim().isNotEmpty) 'notes': notes.trim(),
  };
}
