import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_time.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GlobalNotificationDetailsContent extends StatelessWidget {
  const GlobalNotificationDetailsContent({
    super.key,
    required this.notification,
    required this.showRetry,
    required this.onRetry,
  });
  final AppNotification notification;
  final bool showRetry;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      if (notification.image case final image? when image.isNotEmpty) ...[
        NetworkAttachmentPreview(
          attachmentUrl: image,
          height: 220,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(12),
          title: notification.title,
        ),
        const SizedBox(height: 20),
      ],
      Text(
        notification.title,
        style: StylesManager.styleBold18(context),
      ),
      if (notification.body.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(notification.body, style: StylesManager.styleRegular16(context)),
      ],
      const SizedBox(height: 12),
      NotificationTime(value: notification.createdAt),
      if (showRetry) ...[
        const SizedBox(height: 24),
        CustomAppButton(text: S.of(context).retry, onPressed: onRetry),
      ],
    ],
  );
}
