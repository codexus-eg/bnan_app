import 'chat_search_state.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

sealed class GetRoomMessagesState {}

final class GetRoomMessagesInitial extends GetRoomMessagesState {}

final class GetRoomMessagesLoading extends GetRoomMessagesState {}

final class GetRoomMessagesSuccess extends GetRoomMessagesState {
  GetRoomMessagesSuccess({
    required this.messages,
    this.firstUnreadMessageId,
    this.search = const ChatSearchState(),
  });

  final List<ChatMessageModel> messages;
  final String? firstUnreadMessageId;
  final ChatSearchState search;
}

final class GetRoomMessagesFailure extends GetRoomMessagesState {
  GetRoomMessagesFailure({required this.errorMessage});

  final String errorMessage;
}
