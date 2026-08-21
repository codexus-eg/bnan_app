import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/generated/l10n.dart';

String adminRenewalStatusLabel(S s, AdminRenewalStatus status) =>
    switch (status) {
      AdminRenewalStatus.pending => s.renewalPendingReview,
      AdminRenewalStatus.confirmed => s.renewalPaymentConfirmed,
      AdminRenewalStatus.completed => s.renewalApproved,
      AdminRenewalStatus.rejected => s.renewalRejected,
    };
