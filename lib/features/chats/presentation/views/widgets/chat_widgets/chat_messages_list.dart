import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/chat_search_state.dart';
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
    this.search,
    this.firstUnreadMessageId,
    this.onInitialPositioned,
    this.selectedMessageIds = const {},
    this.selectionMode = false,
    this.canSelect,
    this.onToggleSelection,
    this.onMessageLongPress,
  });

  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool isLoading;
  final String? targetMessageId;
  final ChatSearchState? search;
  final String? firstUnreadMessageId;
  final VoidCallback? onInitialPositioned;
  final Set<String> selectedMessageIds;
  final bool selectionMode;
  final bool Function(ChatMessageModel message)? canSelect;
  final ValueChanged<ChatMessageModel>? onToggleSelection;
  final ValueChanged<ChatMessageModel>? onMessageLongPress;

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
  List<ChatMessageModel> _cachedMessages = const [];

  @override
  void initState() {
    super.initState();
    _cachedMessages = _displayMessages(widget.messages);
    if (!widget.isLoading) {
      final target = _resolveInitialTarget(_cachedMessages);
      if (target != null) {
        _scroll.claimInitialPosition();
        _scrollToInitialTarget(target);
      } else {
        _scroll.initialize(false, _cachedMessages);
      }
    } else {
      _scroll.initialize(true, const []);
    }
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldMessages = _cachedMessages;
    final messages = _displayMessages(widget.messages);
    _cachedMessages = messages;
    final search = widget.search;
    if (search?.targetMessageId != null &&
        (search!.targetMessageId != oldWidget.search?.targetMessageId ||
            search.currentIndex != oldWidget.search?.currentIndex)) {
      final target = search.targetMessageId!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.search?.targetMessageId == target) {
          scrollToMessage(target, transientHighlight: false);
        }
      });
    }
    if (oldWidget.isLoading && !widget.isLoading) {
      final target = _resolveInitialTarget(messages);
      if (target != null) {
        _scroll.claimInitialPosition();
        _scrollToInitialTarget(target);
      } else {
        _scroll.update(
          wasLoading: oldWidget.isLoading,
          isLoading: widget.isLoading,
          oldMessages: oldMessages,
          newMessages: messages,
        );
      }
      return;
    }
    if (search?.isSearching == true) return;
    _scroll.update(
      wasLoading: oldWidget.isLoading,
      isLoading: widget.isLoading,
      oldMessages: oldMessages,
      newMessages: messages,
    );
  }

  String? _resolveInitialTarget(List<ChatMessageModel> messages) {
    final target = (widget.search?.targetMessageId ?? widget.targetMessageId)
        ?.trim();
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
    final messages = _cachedMessages;
    _pruneMessageKeys(messages);
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
        final message = messages[index];
        final isFirstUnread =
            message.id.trim() == widget.firstUnreadMessageId?.trim();
        final bubble = GestureDetector(
          onLongPress: widget.selectionMode
              ? (_canSelect(message)
                  ? () => widget.onToggleSelection?.call(message)
                  : null)
              : () => widget.onMessageLongPress?.call(message),
          onTap: widget.selectionMode && _canSelect(message)
              ? () => widget.onToggleSelection?.call(message)
              : null,
          child: AbsorbPointer(
            absorbing: widget.selectionMode,
            child: ChatBubble(
              key: _targetKey(message.id),
              message: message,
              currentUserId: widget.currentUserId,
              searchQuery: widget.search?.searchQuery ?? '',
              highlighted:
                  message.id.trim() == highlightedMessageId ||
                  message.id.trim() == widget.search?.targetMessageId,
              selected: widget.selectedMessageIds.contains(message.id.trim()),
            ),
          ),
        );

        if (isFirstUnread) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 16),
                child: NewMessagesSeparator(),
              ),
              bubble,
            ],
          );
        }
        return bubble;
      },
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

  Future<void> scrollToMessage(
    String messageId, {
    bool transientHighlight = true,
  }) async {
    final targetId = messageId.trim();
    if (targetId.isEmpty) return;
    final messages = _cachedMessages;
    final index = messages.indexWhere(
      (message) => message.id.trim() == targetId,
    );
    if (index < 0) return;
    highlightTimer?.cancel();
    setState(() => highlightedMessageId = transientHighlight ? targetId : null);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted ||
        (!transientHighlight && widget.search?.targetMessageId != targetId)) {
      return;
    }
    final target = messageKeys[targetId]?.currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 280),
        alignment: .5,
      );
    }
    if (!transientHighlight) {
      return;
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
