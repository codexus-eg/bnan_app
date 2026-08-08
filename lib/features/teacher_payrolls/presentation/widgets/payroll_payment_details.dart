import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'payout_profile_details.dart';
import 'payroll_info_row.dart';
import 'payroll_section.dart';

class PayrollPaymentDetails extends StatelessWidget {
  const PayrollPaymentDetails({super.key, required this.payment});
  final PayrollPaymentModel payment;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PayrollSection(
      title: s.payrollPaymentDetails,
      child: Column(
        children: [
          PayrollInfoRow(label: s.payrollPaidAt, value: payment.paidAt),
          if (payment.transactionReference.isNotEmpty)
            PayrollInfoRow(
              label: s.payrollTransactionReference,
              value: payment.transactionReference,
            ),
          if (payment.destinationSnapshot != null)
            PayoutProfileDetails(profile: payment.destinationSnapshot!),
          if (payment.receiptUrl.isNotEmpty)
            NetworkAttachmentPreview(
              attachmentUrl: payment.receiptUrl,
              title: s.payrollTransferReceipt,
            ),
        ],
      ),
    );
  }
}
