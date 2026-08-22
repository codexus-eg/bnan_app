import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:flutter/material.dart';

class StudentHomeSubscriptions extends StatelessWidget {
  const StudentHomeSubscriptions({
    super.key,
    required this.student,
    required this.subscriptions,
  });
  final ParentChildSubscriptionsModel student;
  final List<ParentChildSubscriptionModel> subscriptions;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        for (var index = 0; index < subscriptions.length; index++) ...[
          ParentSubscriptionCard(
            child: student,
            subscription: subscriptions[index],
            isParent: false,
            showRenew: false,
          ),
          if (index < subscriptions.length - 1) const SizedBox(height: 12),
        ],
      ],
    ),
  );
}
