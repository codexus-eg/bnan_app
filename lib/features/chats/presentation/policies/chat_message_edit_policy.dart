import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

abstract final class ChatMessageEditPolicy {
  static bool canEdit({
    required ChatMessageModel message,
    required String currentUserId,
  }) {
    if (message.deletedForEveryone) return false;
    if (message.isNonDisplayableSessionEvent) return false;
    return message.isMine(currentUserId);
  }
}
