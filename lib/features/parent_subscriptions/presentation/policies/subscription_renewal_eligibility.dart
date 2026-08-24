import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';

abstract final class SubscriptionRenewalEligibility {
  static bool canRenew(
    ParentChildSubscriptionModel subscription, {
    String? registrationMode,
    DateTime? now,
  }) {
    final mode = registrationMode?.trim().toLowerCase();
    if (mode == 'gulf') return subscription.remainingHours <= 0;
    if (subscription.hasPendingRenewal || !subscription.canRenew) {
      return false;
    }
    return switch (subscription.packageType.trim().toLowerCase()) {
      'hours' => subscription.remainingHours <= 0,
      'monthly' => _monthly(subscription, now ?? DateTime.now()),
      _ => false,
    };
  }

  static bool _monthly(
    ParentChildSubscriptionModel subscription,
    DateTime now,
  ) {
    final endDate = subscription.endDate;
    return endDate != null && !now.isBefore(endDate);
  }
}
