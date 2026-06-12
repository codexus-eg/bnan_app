import 'package:bnan_app/features/schedule/data/models/chat_message_model.dart';
import 'package:bnan_app/features/schedule/presentation/views/widgets/chat_widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.messages,
  });

  final List<ChatMessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ChatBubble(message: messages[index]);
      },
    );
  }
}