import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/chat_room_metadata/chat_room_metadata_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomMetadataCubit extends Cubit<ChatRoomMetadataState> {
  ChatRoomMetadataCubit(this._repo, ChatRoomMetadataState initial)
    : super(initial);

  final ChatRepo _repo;

  Future<void> load(String roomId) async {
    final id = roomId.trim();
    if (id.isEmpty || !state.needsLoad || isClosed) return;
    final result = await _repo.getChatRoom(roomId: id);
    if (isClosed) return;
    result.fold((_) {}, (response) => emit(state.merge(response.room)));
  }
}
