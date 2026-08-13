import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_foreground_notification_content.dart';
import 'package:flutter/material.dart';

class ChatForegroundNotification extends StatelessWidget {
  const ChatForegroundNotification({
    super.key,
    required this.sender,
    required this.preview,
    required this.onTap,
  });

  final String sender;
  final String preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(blurRadius: 14, color: Colors.black26)],
        ),
        child: ChatForegroundNotificationContent(
          sender: sender,
          preview: preview,
        ),
      ),
    ),
  );
}
