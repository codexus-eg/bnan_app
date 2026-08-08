import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class PayrollReadOnlyAdjustments extends StatelessWidget {
  const PayrollReadOnlyAdjustments({super.key, required this.payroll});
  final TeacherPayrollModel payroll;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PayrollSection(
      title: s.payrollAdjustments,
      child: Column(
        children: [
          PayrollInfoRow(
            label: s.payrollBonus,
            value: PayrollAmountFormatter.format(payroll.bonus),
          ),
          PayrollInfoRow(
            label: s.payrollDeduction,
            value: PayrollAmountFormatter.format(payroll.deduction),
          ),
          if (payroll.adjustmentNote.isNotEmpty)
            PayrollInfoRow(
              label: s.payrollAdjustmentNote,
              value: payroll.adjustmentNote,
            ),
          if (payroll.notes.isNotEmpty)
            PayrollInfoRow(label: s.notes, value: payroll.notes),
        ],
      ),
    );
  }
}
