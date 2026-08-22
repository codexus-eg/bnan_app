import 'dart:async';

import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/new_messages_separator.dart';
import 'package:flutter/material.dart';

part 'chat_message_display_order.dart';
part 'chat_messages_scroll_controller.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.isLoading = false,
    this.targetMessageId,
    this.firstUnreadMessageId,
    this.onInitialPositioned,
    this.selectedMessageIds = const {},
    this.selectionMode = false,
    this.canSelect,
    this.onToggleSelection,
  });

  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool isLoading;
  final String? targetMessageId;
  final String? firstUnreadMessageId;
  final VoidCallback? onInitialPositioned;
  final Set<String> selectedMessageIds;
  final bool selectionMode;
  final bool Function(ChatMessageModel message)? canSelect;
  final ValueChanged<ChatMessageModel>? onToggleSelection;

  @override
  State<ChatMessagesList> createState() => ChatMessagesListState();
}

class ChatMessagesListState extends State<ChatMessagesList> {
  late final _scroll = _ChatMessagesScrollController(
    onInitialPositioned: widget.onInitialPositioned,
  );
  final messageKeys = <String, GlobalKey>{};
  Timer? highlightTimer;
  String? highlightedMessageId;

  @override
  void initState() {
    super.initState();
    if (!widget.isLoading) {
      final messages = _displayMessages(widget.messages);
      final target = _resolveInitialTarget(messages);
      if (target != null) {
        _scroll.claimInitialPosition();
        _scrollToInitialTarget(target);
      } else {
        _scroll.initialize(false, messages);
      }
    } else {
      _scroll.initialize(true, const []);
    }
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final messages = _displayMessages(widget.messages);
    if (oldWidget.isLoading && !widget.isLoading) {
      final target = _resolveInitialTarget(messages);
      if (target != null) {
        _scroll.claimInitialPosition();
        _scrollToInitialTarget(target);
      } else {
        _scroll.update(
          wasLoading: oldWidget.isLoading,
          isLoading: widget.isLoading,
          oldMessages: _displayMessages(oldWidget.messages),
          newMessages: messages,
        );
      }
      return;
    }
    _scroll.update(
      wasLoading: oldWidget.isLoading,
      isLoading: widget.isLoading,
      oldMessages: _displayMessages(oldWidget.messages),
      newMessages: messages,
    );
  }

  String? _resolveInitialTarget(List<ChatMessageModel> messages) {
    final target = widget.targetMessageId?.trim();
    if (target != null && target.isNotEmpty) {
      if (messages.any((m) => m.id.trim() == target)) {
        return target;
      }
    }
    final unread = widget.firstUnreadMessageId?.trim();
    if (unread != null && unread.isNotEmpty) {
      if (messages.any((m) => m.id.trim() == unread)) {
        return unread;
      }
    }
    return null;
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
            if (messages[index].id.trim() ==
                widget.firstUnreadMessageId?.trim())
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 16),
                child: NewMessagesSeparator(),
              ),
            GestureDetector(
              onLongPress: _canSelect(messages[index])
                  ? () => widget.onToggleSelection?.call(messages[index])
                  : null,
              onTap: widget.selectionMode && _canSelect(messages[index])
                  ? () => widget.onToggleSelection?.call(messages[index])
                  : null,
              child: AbsorbPointer(
                absorbing: widget.selectionMode,
                child: ChatBubble(
                  key: _targetKey(messages[index].id),
                  message: messages[index],
                  currentUserId: widget.currentUserId,
                  highlighted:
                      messages[index].id.trim() == highlightedMessageId,
                  selected: widget.selectedMessageIds.contains(
                    messages[index].id.trim(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canSelect(ChatMessageModel message) =>
      widget.canSelect?.call(message) == true;

  void _scrollToInitialTarget(String messageId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final target = messageKeys[messageId]?.currentContext;
      if (target == null || !target.mounted) return;
      Scrollable.ensureVisible(target, alignment: .1);
      widget.onInitialPositioned?.call();
    });
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
