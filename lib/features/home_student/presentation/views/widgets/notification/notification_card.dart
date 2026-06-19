import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/notification/notification_info.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: notification.isUnread
              ? ColorManager.grey7D7D
              : ColorManager.greyF8F9,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomIconBox(imagePath: ImageManager.bellIcon),
          const SizedBox(width: 8),
          Expanded(child: NotificationInfo(notification: notification)),
          if (notification.isUnread) const SizedBox(width: 8),
          if (notification.isUnread) const _UnreadDot(),
        ],
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 3,
      backgroundColor: ColorManager.mainColor14,
    );
  }
}
