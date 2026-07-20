import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';

sealed class GetChatRoomsState {}

final class GetChatRoomsInitial extends GetChatRoomsState {}

final class GetChatRoomsLoading extends GetChatRoomsState {}

final class GetChatRoomsSuccess extends GetChatRoomsState {
  GetChatRoomsSuccess({required this.rooms});

  final List<ChatRoomSummaryModel> rooms;
}

final class GetChatRoomsFailure extends GetChatRoomsState {
  GetChatRoomsFailure({required this.errorMessage});

  final String errorMessage;
}