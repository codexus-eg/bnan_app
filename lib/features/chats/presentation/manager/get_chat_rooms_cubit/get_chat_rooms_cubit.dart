import 'dart:async';

import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetChatRoomsCubit extends Cubit<GetChatRoomsState> {
  GetChatRoomsCubit(this.chatRepo, [ChatNotificationCoordinator? notifications])
    : super(GetChatRoomsInitial()) {
    _notificationSubscription = notifications?.roomEvents.listen(_updateRoom);
  }

  final ChatRepo chatRepo;
  StreamSubscription<ChatNotificationEvent>? _notificationSubscription;

  Future<void> getChatRooms() async {
    emit(GetChatRoomsLoading());

    final result = await chatRepo.getChatRooms();

    result.fold(
      (failure) {
        emit(GetChatRoomsFailure(errorMessage: failure.message));
      },
      (response) {
        emit(GetChatRoomsSuccess(rooms: response.rooms));
      },
    );
  }

  void _updateRoom(ChatNotificationEvent event) {
    final current = state;
    if (current is! GetChatRoomsSuccess) return;
    final index = current.rooms.indexWhere((room) => room.id == event.roomId);
    if (index == -1) return;

    final rooms = List.of(current.rooms);
    final room = rooms
        .removeAt(index)
        .copyWith(lastMessage: event.message, lastMessageAt: event.createdAt);
    rooms.insert(0, room);
    emit(GetChatRoomsSuccess(rooms: rooms));
  }

  @override
  Future<void> close() async {
    await _notificationSubscription?.cancel();
    return super.close();
  }
}
