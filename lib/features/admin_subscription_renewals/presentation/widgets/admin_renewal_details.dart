import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_subscription_renewal_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminRenewalDetails extends StatelessWidget {
  const AdminRenewalDetails({super.key, required this.item});
  final AdminSubscriptionRenewalModel item;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rows = <(String, String)>[
      (s.curriculum, item.curriculum),
      (s.grade, item.grade),
      (s.packageName, item.packageName),
      (s.packageType, item.packageType),
      if (item.subject != null) (s.subject, item.subject!),
      (s.amount, _amount),
      (s.paymentMethod, item.method),
      if (item.referenceNumber != null)
        (s.renewalReferenceNumber, item.referenceNumber!),
      if (item.requestedBy != null) (s.requester, item.requestedBy!),
      if (item.createdAt != null)
        (
          s.renewalRequestedAt,
          AppPickers.formatDateOnly(item.createdAt!.toIso8601String()),
        ),
      if (item.rejectionReason != null)
        (s.rejectionReason, item.rejectionReason!),
    ];
    return Column(
      children: rows
          .where((row) => row.$2.trim().isNotEmpty)
          .map((row) => ClassMetaRow(label: row.$1, value: row.$2))
          .toList(),
    );
  }

  String get _amount {
    final amount = item.amount?.toString() ?? '';
    return [amount, item.currency].where((value) => value.isNotEmpty).join(' ');
  }
}
