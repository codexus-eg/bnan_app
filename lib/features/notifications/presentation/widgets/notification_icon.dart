import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, required this.notification});
  final AppNotification notification;
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: ColorManager.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(_icon, color: ColorManager.mainColor14, size: 22),
  );
  IconData get _icon => switch (notification.type.toLowerCase()) {
    'chat' => Icons.chat_bubble_outline,
    'classroom' => Icons.video_camera_front_outlined,
    'assignment' => Icons.assignment_outlined,
    'payment' || 'subscription' => Icons.account_balance_wallet_outlined,
    'attendance' => Icons.fact_check_outlined,
    'certificate' => Icons.workspace_premium_outlined,
    'announcement' => Icons.campaign_outlined,
    _ => Icons.notifications_none_outlined,
  };
}
