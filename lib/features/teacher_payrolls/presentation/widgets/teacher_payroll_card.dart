import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/teacher_payroll_presenter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';
import 'payroll_status_badge.dart';

class TeacherPayrollCard extends StatelessWidget {
  const TeacherPayrollCard({super.key, required this.payroll});
  final TeacherPayrollModel payroll;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context),
        month = TeacherPayrollPresenter.month(context, payroll.period);
    final title = month == null
        ? s.teacherPayrollReport
        : s.teacherPayrollReportTitle(
            month,
            DateTime.parse(payroll.period.from).year,
          );
    return PayrollSection(
      title: title,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: PayrollStatusBadge(
              status: payroll.status,
              displayLabel: payroll.status == 'draft'
                  ? s.teacherPayrollUnderReview
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(TeacherPayrollPresenter.range(context, payroll.period)),
          ),
          const SizedBox(height: 8),
          if (payroll.totals.gulfAmount != 0)
            PayrollInfoRow(
              label: s.payrollGulfWork,
              value: PayrollAmountFormatter.format(payroll.totals.gulfAmount),
            ),
          if (payroll.totals.egyptianAmount != 0)
            PayrollInfoRow(
              label: s.payrollEgyptianWork,
              value: PayrollAmountFormatter.format(
                payroll.totals.egyptianAmount,
              ),
            ),
          const Divider(),
          PayrollInfoRow(
            label: s.payrollTotal,
            value:
                '${PayrollAmountFormatter.format(payroll.totals.total)} ${payroll.currency}',
          ),
          if (payroll.status == 'paid' && payroll.payment != null)
            PayrollInfoRow(
              label: s.teacherPayrollPaidOn,
              value: TeacherPayrollPresenter.paidAt(
                context,
                payroll.payment!.paidAt,
              ),
            ),
          if (payroll.status == 'draft') ...[
            const SizedBox(height: 6),
            Text(s.teacherPayrollDraftNote),
          ],
          const SizedBox(height: 12),
          CustomAppButton(
            text:
                payroll.status == 'paid' &&
                    payroll.payment?.receiptUrl.isNotEmpty == true
                ? s.teacherPayrollViewReportReceipt
                : s.teacherPayrollViewReport,
            onPressed: () => MyNavigator.goTo(
              context,
              Routes.teacherMyPayrollReportPath(payroll.id),
            ),
          ),
        ],
      ),
    );
  }
}
