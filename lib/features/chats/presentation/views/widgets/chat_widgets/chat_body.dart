import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/policies/chat_message_delete_policy.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_delete_confirmation.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_input_bar/chat_input_bar.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_title.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({
    super.key,
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.classroomName,
    this.currentUserRole,
  });

  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? classroomName;
  final String? currentUserRole;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final messagesKey = GlobalKey<ChatMessagesListState>();
  final selectedMessageIds = <String>{};
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedMessageIds.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selectedMessageIds.isNotEmpty) _clearSelection();
      },
      child: Column(
        children: [
          ChatHeader(
            chatTitle: resolveChatTitle(context, widget.classroomName),
            roomId: widget.roomId,
            roomType: widget.roomType,
            classroomId: widget.classroomId,
            currentUserRole: widget.currentUserRole,
            onMessageTarget: (id) =>
                messagesKey.currentState?.scrollToMessage(id),
            selectedCount: selectedMessageIds.length,
            isDeleting: isDeleting,
            onCancelSelection: _clearSelection,
            onDeleteSelection: _deleteSelection,
          ),
          Expanded(
            child: BlocConsumer<GetRoomMessagesCubit, GetRoomMessagesState>(
              listener: _pruneSelection,
              builder: (context, state) {
                if (state is GetRoomMessagesFailure) {
                  return Center(child: Text(state.errorMessage));
                }

                if (state is GetRoomMessagesSuccess && state.messages.isEmpty) {
                  return const NoDataWidget();
                }

                final isLoading =
                    state is GetRoomMessagesInitial ||
                    state is GetRoomMessagesLoading;

                final List<ChatMessageModel> messages =
                    state is GetRoomMessagesSuccess
                    ? state.messages
                    : ChatMessageModel.placeholders;

                return AppSkeletonizer(
                  isLoading: isLoading,
                  child: ChatMessagesList(
                    key: messagesKey,
                    messages: messages,
                    currentUserId: SessionManager.instance.userId ?? '',
                    isLoading: isLoading,
                    firstNewMessageId: state is GetRoomMessagesSuccess
                        ? state.firstNewMessageId
                        : null,
                    selectedMessageIds: selectedMessageIds,
                    selectionMode: selectedMessageIds.isNotEmpty,
                    canSelect: _canDelete,
                    onToggleSelection: _toggleSelection,
                  ),
                );
              },
            ),
          ),
          SafeArea(top: false, child: ChatInputBar(roomId: widget.roomId)),
        ],
      ),
    );
  }

  bool _canDelete(ChatMessageModel message) =>
      ChatMessageDeletePolicy.canDelete(
        message: message,
        currentUserRole:
            widget.currentUserRole ?? SessionManager.instance.userRole,
        currentUserId: SessionManager.instance.userId ?? '',
      );

  void _toggleSelection(ChatMessageModel message) {
    if (!_canDelete(message)) return;
    final id = message.id.trim();
    if (id.isEmpty) return;
    setState(() {
      if (!selectedMessageIds.remove(id) && selectedMessageIds.length < 50) {
        selectedMessageIds.add(id);
      }
    });
  }

  void _clearSelection() {
    if (selectedMessageIds.isEmpty || isDeleting) return;
    setState(selectedMessageIds.clear);
  }

  Future<void> _deleteSelection() async {
    if (isDeleting || selectedMessageIds.isEmpty) return;
    if (!await showChatDeleteConfirmation(context, selectedMessageIds.length)) {
      return;
    }
    if (!mounted) return;
    final ids = Set<String>.from(selectedMessageIds);
    setState(() => isDeleting = true);
    final error = await context.read<GetRoomMessagesCubit>().deleteMessages(
      roomId: widget.roomId,
      messageIds: ids,
    );
    if (!mounted) return;
    setState(() {
      isDeleting = false;
      if (error == null) selectedMessageIds.clear();
    });
    if (error != null) showCustomSnackBar(context, error, false);
  }

  void _pruneSelection(BuildContext context, GetRoomMessagesState state) {
    if (state is! GetRoomMessagesSuccess || selectedMessageIds.isEmpty) return;
    final selectable = state.messages
        .where(_canDelete)
        .map((message) => message.id.trim())
        .toSet();
    if (selectedMessageIds.every(selectable.contains)) return;
    setState(() => selectedMessageIds.retainAll(selectable));
  }
}
