import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetChatRoomsCubit extends Cubit<GetChatRoomsState> {
  GetChatRoomsCubit(this.chatRepo) : super(GetChatRoomsInitial());

  final ChatRepo chatRepo;

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
}
