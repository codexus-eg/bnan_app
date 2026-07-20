import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.currentUserId,
  });

  final List<ChatMessageModel> messages;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.only(top:16,start:16,end:16,bottom : 50),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ChatBubble(
          message: messages[index],
          currentUserId: currentUserId,
        );
      },
    );
  }
}