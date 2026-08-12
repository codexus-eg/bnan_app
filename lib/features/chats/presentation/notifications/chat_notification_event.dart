import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_notification_model.dart';

class ChatNotificationEvent {
  const ChatNotificationEvent({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  final String messageId;
  final String roomId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;

  factory ChatNotificationEvent.fromMessage(ChatMessageModel message) {
    final attachmentName = message.attachments.firstOrNull?.fileName ?? '';
    return ChatNotificationEvent(
      messageId: message.id.trim(),
      roomId: message.roomId.trim(),
      senderId: message.sender.id.trim(),
      senderName: message.sender.fullName.trim(),
      message: message.text.trim().isNotEmpty
          ? message.text.trim()
          : attachmentName,
      createdAt: message.createdAt ?? DateTime.now(),
    );
  }

  factory ChatNotificationEvent.fromNotification(
    ChatNotificationModel notification,
  ) {
    final data = notification.data;
    return ChatNotificationEvent(
      messageId: data.messageId.trim().isNotEmpty
          ? data.messageId.trim()
          : notification.resource.id.trim().isNotEmpty
          ? notification.resource.id.trim()
          : notification.key.trim(),
      roomId: data.roomId.trim(),
      senderId: data.senderId.trim(),
      senderName: data.senderName.trim(),
      message: data.message.trim(),
      createdAt: DateTime.now(),
    );
  }

  factory ChatNotificationEvent.fromPush({
    required String messageId,
    required String roomId,
    required String senderId,
    required String senderName,
    required String message,
  }) => ChatNotificationEvent(
    messageId: messageId,
    roomId: roomId,
    senderId: senderId,
    senderName: senderName,
    message: message,
    createdAt: DateTime.now(),
  );
}
