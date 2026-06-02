import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationInfo extends StatelessWidget {
  const NotificationInfo({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          notification.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          notification.time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}