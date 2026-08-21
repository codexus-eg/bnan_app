import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewal_model.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_actions.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_details.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_labels.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/receipt_download_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminRenewalCard extends StatelessWidget {
  const AdminRenewalCard({super.key, required this.item});
  final AdminSubscriptionRenewalModel item;

  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardHeader(
          name: item.studentName,
          phone: item.studentEmail,
          subtitle: adminRenewalStatusLabel(S.of(context), item.status),
        ),
        const SizedBox(height: 12),
        AdminRenewalDetails(item: item),
        if (item.receiptImage != null) ...[
          Row(
            children: [
              Text(S.of(context).renewalViewReceipt),
              ReceiptDownloadButton(receiptUrl: item.receiptImage!),
            ],
          ),
          const SizedBox(height: 8),
        ],
        AdminRenewalActions(id: item.id, status: item.status),
      ],
    ),
  );
}
