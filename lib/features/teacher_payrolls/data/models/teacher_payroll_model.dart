import 'payroll_parsing.dart';
import 'payroll_payment_model.dart';
import 'payroll_period_model.dart';
import 'payroll_teacher_model.dart';
import 'payroll_totals_model.dart';
import 'payroll_work_item_model.dart';
import 'payout_profile_model.dart';

class TeacherPayrollModel {
  const TeacherPayrollModel({
    required this.id,
    required this.status,
    required this.teacher,
    required this.period,
    required this.workItems,
    required this.currency,
    required this.bonus,
    required this.deduction,
    required this.adjustmentNote,
    required this.notes,
    required this.excludedSessions,
    required this.warnings,
    required this.totals,
    this.payoutProfile,
    this.payment,
  });
  final String id, status, currency, adjustmentNote, notes;
  final PayrollTeacherModel teacher;
  final PayrollPeriodModel period;
  final List<PayrollWorkItemModel> workItems;
  final double bonus, deduction;
  final int excludedSessions;
  final List<String> warnings;
  final PayrollTotalsModel totals;
  final PayoutProfileModel? payoutProfile;
  final PayrollPaymentModel? payment;

  factory TeacherPayrollModel.fromResponse(Object? response) {
    final json = payrollData(response);
    final teacher = payrollMap(json['teacher'] ?? json['teacherId']);
    final summary = payrollMap(json['summary']);
    final profile = json['payoutProfile'];
    final payment = json['payment'];
    return TeacherPayrollModel(
      id: payrollString(json['_id'] ?? json['id'] ?? json['payrollId']),
      status: payrollString(
        json['status'] ?? json['payrollStatus'] ?? 'unprepared',
      ),
      teacher: PayrollTeacherModel.fromJson({
        ...teacher,
        'teacherId': json['teacherId'] is Map
            ? teacher['_id'] ?? teacher['id']
            : json['teacherId'] ?? teacher['teacherId'],
      }),
      period: PayrollPeriodModel.fromJson(json['period']),
      workItems: payrollList(
        json['workItems'],
      ).map(PayrollWorkItemModel.fromJson).toList(),
      currency: payrollString(json['currency'] ?? 'EGP'),
      bonus: payrollDouble(json['bonus']),
      deduction: payrollDouble(json['deduction']),
      adjustmentNote: payrollString(json['adjustmentNote']),
      notes: payrollString(json['notes']),
      excludedSessions: payrollInt(
        json['excludedSessionsCount'] ?? summary['excludedSessionsCount'],
      ),
      warnings: payrollList(
        json['warnings'],
      ).map(payrollString).where((e) => e.isNotEmpty).toList(),
      totals: PayrollTotalsModel.fromJson(json['totals']),
      payoutProfile: profile is Map
          ? PayoutProfileModel.fromJson(profile)
          : null,
      payment: payment is Map ? PayrollPaymentModel.fromJson(payment) : null,
    );
  }
}
