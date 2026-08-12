import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notification_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorNotificationsSection extends StatelessWidget {
  const SupervisorNotificationsSection({
    super.key,
    required this.notifications,
    required this.onTap,
  });
  final List<DashboardNotification> notifications;
  final ValueChanged<DashboardNotification> onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        S.of(context).notifications,
        style: StylesManager.styleBold16(context),
      ),
      const SizedBox(height: 12),
      if (notifications.isEmpty)
        SizedBox(
          height: 180,
          child: NoDataWidget(title: S.of(context).noNotifications),
        )
      else
        for (final notification in notifications)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => onTap(notification),
              child: NotificationCard(
                notification: NotificationModel(
                  title: notification.title,
                  time: notification.time,
                  isUnread: !notification.isRead,
                ),
              ),
            ),
          ),
    ],
  );
}
