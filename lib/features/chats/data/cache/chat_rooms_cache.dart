import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';

class ChatRoomsCache {
  ChatRoomsCache(this._session);

  final SessionManager _session;
  List<ChatRoomSummaryModel> _rooms = const [];
  String? _ownerId;
  final _roomReadEvents = StreamController<String>.broadcast(sync: true);

  Stream<String> get roomReadEvents => _roomReadEvents.stream;

  ChatRoomSummaryModel? find(String targetId) {
    _clearForAnotherUser();
    final id = targetId.trim();
    if (id.isEmpty) return null;
    for (final room in _rooms) {
      if (room.id.trim() == id || room.classroomId?.trim() == id) return room;
    }
    return null;
  }

  void replace(Iterable<ChatRoomSummaryModel> rooms) {
    _ownerId = _session.userId;
    _rooms = List.unmodifiable(rooms);
  }

  void markRoomRead(String roomId) {
    _clearForAnotherUser();
    final id = roomId.trim();
    if (id.isEmpty) return;
    final index = _rooms.indexWhere((r) => r.id.trim() == id);
    if (index != -1 && _rooms[index].unreadCount > 0) {
      final updated = List.of(_rooms);
      updated[index] = updated[index].copyWith(unreadCount: 0);
      _rooms = List.unmodifiable(updated);
    }
    _roomReadEvents.add(id);
  }

  void _clearForAnotherUser() {
    if (_ownerId == _session.userId) return;
    _ownerId = _session.userId;
    _rooms = const [];
  }
}
