import 'payroll_period_model.dart';

class PayrollGradeRateRequest {
  const PayrollGradeRateRequest({
    required this.gradeId,
    required this.hourlyRate,
  });
  final String gradeId;
  final double hourlyRate;
  Map<String, dynamic> toJson() => {'gradeId': gradeId, 'hourlyRate': hourlyRate};
}

class PayrollCourseRateRequest {
  const PayrollCourseRateRequest({
    required this.courseId,
    required this.hourlyRate,
  });
  final String courseId;
  final double hourlyRate;
  Map<String, dynamic> toJson() => {'courseId': courseId, 'hourlyRate': hourlyRate};
}

class PayrollRateRequest {
  const PayrollRateRequest(this.gradeId, this.rate);
  final String gradeId;
  final double rate;
  Map<String, dynamic> toJson() => {'gradeId': gradeId, 'rate': rate};
}

class SavePayrollRequest {
  const SavePayrollRequest({
    this.teacherId,
    this.curriculumId,
    this.from,
    this.to,
    this.period,
    required this.currency,
    this.academicCurrency,
    this.courseCurrency,
    this.generalAmount,
    this.bonuses,
    this.deductions,
    this.gradeRates = const [],
    this.courseRates = const [],
    this.rates = const [],
    this.bonus = 0,
    this.deduction = 0,
    this.adjustmentNote = '',
    this.notes = '',
  });

  final String? teacherId, curriculumId, from, to;
  final PayrollPeriodModel? period;
  final String currency, adjustmentNote, notes;
  final String? academicCurrency, courseCurrency;
  final double? generalAmount, bonuses, deductions;
  final List<PayrollGradeRateRequest> gradeRates;
  final List<PayrollCourseRateRequest> courseRates;
  final List<PayrollRateRequest> rates;
  final double bonus, deduction;

  Map<String, dynamic> toJson() {
    final effectiveFrom = from ?? period?.from;
    final effectiveTo = to ?? period?.to;
    final effectiveBonus = bonuses ?? bonus;
    final effectiveDeduction = deductions ?? deduction;
    final effectiveGradeRates = gradeRates.isNotEmpty
        ? gradeRates
        : rates
            .map(
              (r) => PayrollGradeRateRequest(
                gradeId: r.gradeId,
                hourlyRate: r.rate,
              ),
            )
            .toList();

    final hasGrades = effectiveGradeRates.isNotEmpty;
    final hasCourses = courseRates.isNotEmpty;
    final acadCurr = academicCurrency ?? (hasGrades ? currency : null);
    final crsCurr = courseCurrency ?? (hasCourses ? currency : null);

    return {
      if (teacherId != null && teacherId!.isNotEmpty) 'teacherId': teacherId,
      if (curriculumId != null && curriculumId!.isNotEmpty)
        'curriculumId': curriculumId,
      if (effectiveFrom != null && effectiveFrom.isNotEmpty)
        'from': effectiveFrom,
      if (effectiveTo != null && effectiveTo.isNotEmpty) 'to': effectiveTo,
      'currency': currency,
      if (hasGrades && acadCurr != null) 'academicCurrency': acadCurr,
      if (hasCourses && crsCurr != null) 'courseCurrency': crsCurr,
      if (generalAmount != null) 'generalAmount': generalAmount,
      'bonuses': effectiveBonus,
      'deductions': effectiveDeduction,
      'gradeRates': effectiveGradeRates.map((e) => e.toJson()).toList(),
      'courseRates': courseRates.map((e) => e.toJson()).toList(),
      if (rates.isNotEmpty) 'rates': rates.map((e) => e.toJson()).toList(),
      'bonus': effectiveBonus,
      'deduction': effectiveDeduction,
      if (adjustmentNote.trim().isNotEmpty)
        'adjustmentNote': adjustmentNote.trim(),
      if (notes.trim().isNotEmpty) 'notes': notes.trim(),
    };
  }

  Map<String, dynamic> toPatchJson() {
    final effectiveBonus = bonuses ?? bonus;
    final effectiveDeduction = deductions ?? deduction;
    final effectiveGradeRates = gradeRates.isNotEmpty
        ? gradeRates
        : rates
            .map(
              (r) => PayrollGradeRateRequest(
                gradeId: r.gradeId,
                hourlyRate: r.rate,
              ),
            )
            .toList();

    return {
      'gradeRates': effectiveGradeRates.map((e) => e.toJson()).toList(),
      'courseRates': courseRates.map((e) => e.toJson()).toList(),
      'bonuses': effectiveBonus,
      'deductions': effectiveDeduction,
    };
  }
}
