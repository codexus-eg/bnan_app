import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
    required this.notifications,
  });

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
        },
      ),
    );
  }
}