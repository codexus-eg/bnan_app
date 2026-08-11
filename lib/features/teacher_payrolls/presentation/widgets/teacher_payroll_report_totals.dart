import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class TeacherPayrollReportTotals extends StatelessWidget {
  const TeacherPayrollReportTotals({super.key, required this.payroll});
  final TeacherPayrollModel payroll;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context),
        t = payroll.totals,
        amount = PayrollAmountFormatter.format;
    return PayrollSection(
      title: s.teacherPayrollReportSummary,
      child: Column(
        children: [
          if (t.gulfAmount != 0)
            PayrollInfoRow(
              label: s.payrollGulfWork,
              value: amount(t.gulfAmount),
            ),
          if (t.egyptianAmount != 0)
            PayrollInfoRow(
              label: s.payrollEgyptianWork,
              value: amount(t.egyptianAmount),
            ),
          if (t.bonus != 0)
            PayrollInfoRow(label: s.payrollBonus, value: amount(t.bonus)),
          if (t.deduction != 0)
            PayrollInfoRow(
              label: s.payrollDeduction,
              value: amount(t.deduction),
            ),
          const Divider(),
          PayrollInfoRow(
            label: s.payrollTotal,
            value: '${amount(t.total)} ${payroll.currency}',
          ),
        ],
      ),
    );
  }
}
