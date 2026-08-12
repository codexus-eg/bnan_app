import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:flutter/material.dart';

part 'chat_message_display_order.dart';
part 'chat_messages_scroll_controller.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.isLoading = false,
  });

  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool isLoading;

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  late final _scroll = _ChatMessagesScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.initialize(widget.isLoading, _orderedMessages(widget.messages));
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scroll.update(
      wasLoading: oldWidget.isLoading,
      isLoading: widget.isLoading,
      oldMessages: _orderedMessages(oldWidget.messages),
      newMessages: _orderedMessages(widget.messages),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = _orderedMessages(widget.messages);
    return ListView.separated(
      controller: _scroll.controller,
      padding: const EdgeInsetsDirectional.only(
        top: 16,
        start: 16,
        end: 16,
        bottom: 50,
      ),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ChatBubble(
          message: messages[index],
          currentUserId: widget.currentUserId,
        );
      },
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
