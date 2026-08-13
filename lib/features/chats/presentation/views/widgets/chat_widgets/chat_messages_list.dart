import 'dart:async';

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
  State<ChatMessagesList> createState() => ChatMessagesListState();
}

class ChatMessagesListState extends State<ChatMessagesList> {
  late final _scroll = _ChatMessagesScrollController();
  final messageKeys = <String, GlobalKey>{};
  Timer? highlightTimer;
  String? highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _scroll.initialize(widget.isLoading, _displayMessages(widget.messages));
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scroll.update(
      wasLoading: oldWidget.isLoading,
      isLoading: widget.isLoading,
      oldMessages: _displayMessages(oldWidget.messages),
      newMessages: _displayMessages(widget.messages),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = _displayMessages(widget.messages);
    _pruneMessageKeys(messages);
    return SingleChildScrollView(
      controller: _scroll.controller,
      padding: const EdgeInsetsDirectional.only(
        top: 16,
        start: 16,
        end: 16,
        bottom: 50,
      ),
      child: Column(
        children: [
          for (var index = 0; index < messages.length; index++) ...[
            if (index > 0) const SizedBox(height: 16),
            ChatBubble(
              key: _targetKey(messages[index].id),
              message: messages[index],
              currentUserId: widget.currentUserId,
              highlighted: messages[index].id.trim() == highlightedMessageId,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> scrollToMessage(String messageId) async {
    final targetId = messageId.trim();
    if (targetId.isEmpty) return;
    final messages = _displayMessages(widget.messages);
    final index = messages.indexWhere(
      (message) => message.id.trim() == targetId,
    );
    if (index < 0) return;
    highlightTimer?.cancel();
    setState(() => highlightedMessageId = targetId);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final target = messageKeys[targetId]?.currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 280),
        alignment: .5,
      );
    }
    highlightTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => highlightedMessageId = null);
    });
  }

  Key? _targetKey(String messageId) {
    final id = messageId.trim();
    return id.isEmpty ? null : messageKeys.putIfAbsent(id, GlobalKey.new);
  }

  void _pruneMessageKeys(List<ChatMessageModel> messages) {
    final activeIds = messages.map((message) => message.id.trim()).toSet();
    messageKeys.removeWhere((id, _) => !activeIds.contains(id));
  }

  @override
  void dispose() {
    highlightTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }
}
