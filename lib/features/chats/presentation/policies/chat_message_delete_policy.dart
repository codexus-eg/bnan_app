import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

abstract final class ChatMessageDeletePolicy {
  static bool canDelete({
    required ChatMessageModel message,
    required String? currentUserRole,
    required String currentUserId,
  }) {
    if (message.deletedForEveryone) return false;
    final role = currentUserRole?.trim().toLowerCase();
    return switch (role) {
      'admin' => true,
      'supervisor' => message.sender.role.trim().toLowerCase() != 'admin',
      'student' || 'parent' || 'teacher' => message.isMine(currentUserId),
      _ => false,
    };
  }
}
