import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/policies/chat_message_delete_policy.dart';
import 'package:bnan_app/features/chats/presentation/policies/chat_message_edit_policy.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_delete_confirmation.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_edit_message_dialog.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_message_actions_sheet.dart';
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
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal,
    this.classroomSubjectAmbiguous,
    this.classroomName,
    this.currentUserRole,
    this.studentId,
    this.targetMessageId,
  });

  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool? canRequestTeacherWithdrawal;
  final bool? classroomSubjectAmbiguous;
  final String? classroomName;
  final String? currentUserRole;
  final String? studentId;
  final String? targetMessageId;

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
      child: BlocConsumer<GetRoomMessagesCubit, GetRoomMessagesState>(
        listener: _pruneSelection,
        builder: (context, state) {
          final cubit = context.read<GetRoomMessagesCubit>();
          final searchState = state is GetRoomMessagesSuccess
              ? state.search
              : null;

          return Column(
            children: [
              ChatHeader(
                chatTitle: resolveChatTitle(context, widget.classroomName),
                roomId: widget.roomId,
                roomType: widget.roomType,
                classroomId: widget.classroomId,
                accessScope: widget.accessScope,
                classroomSubjectId: widget.classroomSubjectId,
                canRequestTeacherWithdrawal: widget.canRequestTeacherWithdrawal,
                classroomSubjectAmbiguous: widget.classroomSubjectAmbiguous,
                currentUserRole: widget.currentUserRole,
                studentId: widget.studentId,
                onMessageTarget: (id) =>
                    messagesKey.currentState?.scrollToMessage(id),
                onSearch: cubit.openSearch,
                searchState: searchState,
                onSearchQueryChanged: cubit.updateSearchQuery,
                onNextSearch: cubit.nextSearchResult,
                onPreviousSearch: cubit.previousSearchResult,
                onCloseSearch: cubit.closeSearch,
                selectedCount: selectedMessageIds.length,
                isDeleting: isDeleting,
                canEditSelected: _canEditSelectedMessage(state),
                onCancelSelection: _clearSelection,
                onDeleteSelection: _deleteSelection,
                onEditSelection: () => _editSelectedMessage(state),
              ),
              Expanded(child: _buildMessagesView(context, state, searchState)),
              SafeArea(
                top: false,
                child: ChatInputBar(
                  key: ValueKey(widget.roomId),
                  roomId: widget.roomId,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessagesView(
    BuildContext context,
    GetRoomMessagesState state,
    dynamic searchState,
  ) {
    if (state is GetRoomMessagesFailure) {
      return Center(child: Text(state.errorMessage));
    }

    if (state is GetRoomMessagesSuccess && state.messages.isEmpty) {
      context.read<GetRoomMessagesCubit>().markCurrentRoomRead();
      return const NoDataWidget();
    }

    final isLoading =
        state is GetRoomMessagesInitial || state is GetRoomMessagesLoading;

    final List<ChatMessageModel> messages = state is GetRoomMessagesSuccess
        ? state.messages
        : ChatMessageModel.placeholders;

    return AppSkeletonizer(
      isLoading: isLoading,
      child: ChatMessagesList(
        key: messagesKey,
        messages: messages,
        currentUserId: SessionManager.instance.userId ?? '',
        isLoading: isLoading,
        search: searchState,
        targetMessageId: widget.targetMessageId,
        firstUnreadMessageId: state is GetRoomMessagesSuccess
            ? state.firstUnreadMessageId
            : null,
        onInitialPositioned: context
            .read<GetRoomMessagesCubit>()
            .markCurrentRoomRead,
        selectedMessageIds: selectedMessageIds,
        selectionMode: selectedMessageIds.isNotEmpty,
        canSelect: _canDelete,
        onToggleSelection: _toggleSelection,
        onMessageLongPress: _onMessageLongPress,
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

  bool _canEdit(ChatMessageModel message) =>
      ChatMessageEditPolicy.canEdit(
        message: message,
        currentUserId: SessionManager.instance.userId ?? '',
      );

  bool _canEditSelectedMessage(GetRoomMessagesState state) {
    if (selectedMessageIds.length != 1 || state is! GetRoomMessagesSuccess) {
      return false;
    }
    final selectedId = selectedMessageIds.first;
    final message = state.messages.firstWhere(
      (m) => m.id.trim() == selectedId,
      orElse: () => ChatMessageModel.placeholder,
    );
    return message.id.trim().isNotEmpty && _canEdit(message);
  }

  Future<void> _editSelectedMessage(GetRoomMessagesState state) async {
    if (selectedMessageIds.length != 1 || state is! GetRoomMessagesSuccess) {
      return;
    }
    final selectedId = selectedMessageIds.first;
    final message = state.messages.firstWhere(
      (m) => m.id.trim() == selectedId,
      orElse: () => ChatMessageModel.placeholder,
    );
    if (message.id.trim().isEmpty || !_canEdit(message)) return;
    final edited = await showEditChatMessageDialog(context, message);
    if (edited && mounted) {
      _clearSelection();
    }
  }

  Future<void> _onMessageLongPress(ChatMessageModel message) async {
    final canEdit = _canEdit(message);
    final canDelete = _canDelete(message);
    if (!canEdit && !canDelete) return;

    final action = await showChatMessageActionsSheet(
      context,
      message: message,
      canEdit: canEdit,
      canDelete: canDelete,
    );
    if (!mounted || action == null) return;

    switch (action) {
      case ChatMessageMenuAction.edit:
        final edited = await showEditChatMessageDialog(context, message);
        if (edited && mounted) _clearSelection();
      case ChatMessageMenuAction.delete:
        await _deleteSingleMessage(message);
      case ChatMessageMenuAction.select:
        _toggleSelection(message);
    }
  }

  Future<void> _deleteSingleMessage(ChatMessageModel message) async {
    if (isDeleting) return;
    if (!await showChatDeleteConfirmation(context, 1)) return;
    if (!mounted) return;
    setState(() => isDeleting = true);
    final error = await context.read<GetRoomMessagesCubit>().deleteSingleMessage(
      messageId: message.id,
    );
    if (!mounted) return;
    setState(() {
      isDeleting = false;
      selectedMessageIds.remove(message.id.trim());
    });
    if (error != null) showCustomSnackBar(context, error, false);
  }

  void _pruneSelection(BuildContext context, GetRoomMessagesState state) {
    if (state is! GetRoomMessagesSuccess || selectedMessageIds.isEmpty) {
      return;
    }
    final selectable = state.messages
        .where(_canDelete)
        .map((message) => message.id.trim())
        .toSet();
    if (selectedMessageIds.every(selectable.contains)) return;
    setState(() => selectedMessageIds.retainAll(selectable));
  }
}
