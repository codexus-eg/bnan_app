import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notification_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorNotificationsSection extends StatelessWidget {
  const SupervisorNotificationsSection({
    super.key,
    required this.notifications,
  });

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.notifications, style: StylesManager.styleBold16(context)),
        const SizedBox(height: 12),
        if (notifications.isEmpty)
          SizedBox(height: 180, child: NoDataWidget(title: s.noNotifications))
        else
          ...List.generate(
            notifications.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == notifications.length - 1 ? 0 : 12,
              ),
              child: NotificationCard(notification: notifications[index]),
            ),
          ),
      ],
    );
  }
}
