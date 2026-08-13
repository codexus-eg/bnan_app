import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_input_bar/chat_input_bar.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatHeader(
          chatTitle: widget.classroomName ?? '',
          roomId: widget.roomId,
          roomType: widget.roomType,
          classroomId: widget.classroomId,
          currentUserRole: widget.currentUserRole,
          onMessageTarget: (id) =>
              messagesKey.currentState?.scrollToMessage(id),
        ),
        Expanded(
          child: BlocBuilder<GetRoomMessagesCubit, GetRoomMessagesState>(
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
                ),
              );
            },
          ),
        ),
        ChatInputBar(roomId: widget.roomId),
      ],
    );
  }
}
