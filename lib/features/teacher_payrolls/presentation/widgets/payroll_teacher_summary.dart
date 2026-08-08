import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';
import 'payroll_status_badge.dart';

class PayrollTeacherSummary extends StatelessWidget {
  const PayrollTeacherSummary({super.key, required this.payroll});
  final TeacherPayrollModel payroll;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PayrollSection(
      title: s.payrollTeacherDetails,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: PayrollStatusBadge(status: payroll.status),
          ),
          PayrollInfoRow(label: s.name, value: payroll.teacher.fullName),
          PayrollInfoRow(label: s.email, value: payroll.teacher.email),
          if (payroll.teacher.phone.isNotEmpty)
            PayrollInfoRow(label: s.phoneNumber, value: payroll.teacher.phone),
          PayrollInfoRow(
            label: s.payrollPeriod,
            value: '${payroll.period.from} — ${payroll.period.to}',
          ),
        ],
      ),
    );
  }
}
