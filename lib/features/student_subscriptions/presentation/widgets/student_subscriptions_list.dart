import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';

class StudentSubscriptionsList extends StatelessWidget {
  const StudentSubscriptionsList({
    super.key,
    required this.student,
    required this.onRefresh,
  });
  final ParentChildSubscriptionsModel student;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: student.subscriptions.isEmpty
        ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 360, child: NoDataWidget())],
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: student.subscriptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) => ParentSubscriptionCard(
              child: student,
              subscription: student.subscriptions[index],
              isParent: false,
              onRenewed: onRefresh,
            ),
          ),
  );
}
