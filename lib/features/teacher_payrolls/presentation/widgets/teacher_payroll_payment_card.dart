import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_amount_formatter.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/teacher_payroll_presenter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payout_profile_details.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class TeacherPayrollPaymentCard extends StatelessWidget {
  const TeacherPayrollPaymentCard({super.key, required this.payroll});
  final TeacherPayrollModel payroll;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context), payment = payroll.payment;
    if (payroll.status != 'paid' || payment == null) {
      return PayrollSection(
        title: s.teacherPayrollPaymentDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.teacherPayrollNotTransferred),
            const SizedBox(height: 6),
            Text(s.teacherPayrollReceiptLater),
          ],
        ),
      );
    }
    return PayrollSection(
      title: s.teacherPayrollPaymentDetails,
      child: Column(
        children: [
          PayrollInfoRow(label: s.payrollStatus, value: s.payrollPaid),
          PayrollInfoRow(
            label: s.payrollAmount,
            value:
                '${PayrollAmountFormatter.format(payroll.totals.total)} ${payroll.currency}',
          ),
          PayrollInfoRow(label: s.teacherPayrollMethod, value: payment.method),
          PayrollInfoRow(
            label: s.payrollPaidAt,
            value: TeacherPayrollPresenter.paidAt(context, payment.paidAt),
          ),
          if (payment.transactionReference.isNotEmpty)
            PayrollInfoRow(
              label: s.payrollTransactionReference,
              value: payment.transactionReference,
            ),
          if (payment.destinationSnapshot != null) ...[
            const Divider(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(s.teacherPayrollTransferredTo),
            ),
            PayoutProfileDetails(profile: payment.destinationSnapshot!),
          ],
          if (payment.receiptUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            CustomAppButton(
              text: s.teacherPayrollReceipt,
              onPressed: () => _receipt(context, payment.receiptUrl),
            ),
          ],
        ],
      ),
    );
  }

  void _receipt(BuildContext context, String url) => showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: NetworkAttachmentPreview(
          attachmentUrl: url,
          title: S.of(context).teacherPayrollReceipt,
        ),
      ),
    ),
  );
}
