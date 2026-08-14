import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';

class ChatRoomsCache {
  ChatRoomsCache(this._session);

  final SessionManager _session;
  List<ChatRoomSummaryModel> _rooms = const [];
  String? _ownerId;

  ChatRoomSummaryModel? find(String roomId) {
    _clearForAnotherUser();
    final id = roomId.trim();
    for (final room in _rooms) {
      if (room.id.trim() == id) return room;
    }
    return null;
  }

  void replace(Iterable<ChatRoomSummaryModel> rooms) {
    _ownerId = _session.userId;
    _rooms = List.unmodifiable(rooms);
  }

  void _clearForAnotherUser() {
    if (_ownerId == _session.userId) return;
    _ownerId = _session.userId;
    _rooms = const [];
  }
}
