import 'package:flutter/material.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_my_payrolls_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'payroll_info_row.dart';

class TeacherPayrollSummaryCard extends StatelessWidget {
  const TeacherPayrollSummaryCard({super.key, required this.summary});
  final TeacherPayrollCurrencySummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context), amount = PayrollAmountFormatter.format;
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary.currency, style: StylesManager.styleBold18(context)),
          const SizedBox(height: 12),
          PayrollInfoRow(
            label: s.teacherPayrollPreparingAmount,
            value: amount(summary.draftAmount),
          ),
          PayrollInfoRow(
            label: s.teacherPayrollPaidAmount,
            value: amount(summary.paidAmount),
          ),
          const Divider(),
          PayrollInfoRow(
            label: s.payrollTotal,
            value: '${amount(summary.totalAmount)} ${summary.currency}',
          ),
        ],
      ),
    );
  }
}
