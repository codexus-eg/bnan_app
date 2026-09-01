import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class TeacherPayrollReportWorkItem extends StatelessWidget {
  const TeacherPayrollReportWorkItem({
    super.key,
    required this.item,
    required this.currency,
  });
  final PayrollWorkItemModel item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context), amount = PayrollAmountFormatter.format;
    return PayrollSection(
      title: '${item.curriculumName} - ${item.gradeName}',
      child: Column(
        children: [
          PayrollInfoRow(
            label: s.payrollSystem,
            value: item.system == 'gulf' ? s.payrollGulf : s.payrollEgyptian,
          ),
          PayrollInfoRow(label: s.payrollDuration, value: item.displayDuration),
          PayrollInfoRow(
            label: s.payrollSessionsCount,
            value: '${item.sessionsCount}',
          ),
          PayrollInfoRow(
            label: s.payrollHourlyRate,
            value: '${amount(item.rate)} $currency',
          ),
          PayrollInfoRow(
            label: s.payrollAmount,
            value: '${amount(item.amount)} $currency',
          ),
        ],
      ),
    );
  }
}
