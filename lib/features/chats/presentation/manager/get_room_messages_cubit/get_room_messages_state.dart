import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

sealed class GetRoomMessagesState {}

final class GetRoomMessagesInitial extends GetRoomMessagesState {}

final class GetRoomMessagesLoading extends GetRoomMessagesState {}

final class GetRoomMessagesSuccess extends GetRoomMessagesState {
  GetRoomMessagesSuccess({required this.messages, this.firstNewMessageId});

  final List<ChatMessageModel> messages;
  final String? firstNewMessageId;
}

final class GetRoomMessagesFailure extends GetRoomMessagesState {
  GetRoomMessagesFailure({required this.errorMessage});

  final String errorMessage;
}
