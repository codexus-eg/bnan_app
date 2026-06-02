import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notifications_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationModel(
        title: S.of(context).lessonStartsSoon,
        time: S.of(context).todayAtTime('5:45 م'),
        isUnread: true,
      ),
      NotificationModel(
        title: S.of(context).newRating,
        time: S.of(context).todayAtTime('3:10 م'),
        isUnread: true,
      ),
      NotificationModel(
        title: S.of(context).certificateReceived,
        time: S.of(context).yesterday,
      ),
      NotificationModel(
        title: S.of(context).newMessage,
        time: S.of(context).yesterday,
      ),
      NotificationModel(
        title: S.of(context).subscriptionEndsSoon,
        time: S.of(context).twoDaysAgo,
      ),
      NotificationModel(
        title: S.of(context).scheduleUpdated,
        time: S.of(context).threeDaysAgo,
      ),
      NotificationModel(
        title: S.of(context).newAssignmentUploaded,
        time: S.of(context).fourDaysAgo,
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(S.of(context).markAsRead,style: StylesManager.styleBold14(context).copyWith(
              color: ColorManager.black
            )),
            const SizedBox(height: 16),
            NotificationsList(notifications: notifications),
          ],
        ),
      ),
    );
  }
}