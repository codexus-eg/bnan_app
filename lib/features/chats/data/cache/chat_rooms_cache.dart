import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';

class ChatRoomsCache {
  ChatRoomsCache(this._session) {
    _session.addSessionChangeListener(_onSessionChanged);
  }

  final SessionManager _session;
  List<ChatRoomSummaryModel> _rooms = const [];
  String? _ownerId;
  final _roomReadEvents = StreamController<String>.broadcast(sync: true);
  final _roomsUpdateEvents =
      StreamController<List<ChatRoomSummaryModel>>.broadcast(sync: true);

  Future<void> _onSessionChanged(String? prev, String? next) async {
    if (prev != next) clear();
  }

  Stream<String> get roomReadEvents => _roomReadEvents.stream;
  Stream<List<ChatRoomSummaryModel>> get roomsUpdateEvents =>
      _roomsUpdateEvents.stream;
  List<ChatRoomSummaryModel> get rooms {
    _clearForAnotherUser();
    return _rooms;
  }

  ChatRoomSummaryModel? find(String targetId) {
    _clearForAnotherUser();
    final id = targetId.trim();
    if (id.isEmpty) return null;
    for (final room in _rooms) {
      if (room.id.trim() == id || room.classroomId?.trim() == id) return room;
    }
    return null;
  }

  ChatRoomSummaryModel? findByClassroom({
    required String classroomId,
    String? classroomSubjectId,
  }) {
    _clearForAnotherUser();
    return findRoomByClassroom(
      _rooms,
      classroomId: classroomId,
      classroomSubjectId: classroomSubjectId,
    );
  }

  static ChatRoomSummaryModel? findRoomByClassroom(
    Iterable<ChatRoomSummaryModel> rooms, {
    required String classroomId,
    String? classroomSubjectId,
  }) {
    final cId = classroomId.trim();
    if (cId.isEmpty) return null;
    final sId = classroomSubjectId?.trim();
    if (sId != null && sId.isNotEmpty) {
      for (final room in rooms) {
        if (room.classroomId?.trim() == cId &&
            room.classroomSubjectId?.trim() == sId) {
          return room;
        }
      }
      for (final room in rooms) {
        if (room.classroomId?.trim() == cId &&
            (room.classroomSubjectId == null ||
                room.classroomSubjectId!.trim().isEmpty)) {
          return room;
        }
      }
      return null;
    }
    for (final room in rooms) {
      if (room.classroomId?.trim() == cId) {
        return room;
      }
    }
    return null;
  }

  void replace(Iterable<ChatRoomSummaryModel> rooms) {
    _ownerId = _session.userId;
    _rooms = List.unmodifiable(rooms);
    _roomsUpdateEvents.add(_rooms);
  }

  void markRoomRead(String roomId) {
    _clearForAnotherUser();
    final id = roomId.trim();
    if (id.isEmpty) return;
    final index = _rooms.indexWhere(
      (r) => r.id.trim() == id || r.classroomId?.trim() == id,
    );
    if (index != -1 && _rooms[index].unreadCount > 0) {
      final updated = List.of(_rooms);
      updated[index] = updated[index].copyWith(unreadCount: 0);
      _rooms = List.unmodifiable(updated);
      _roomsUpdateEvents.add(_rooms);
    }
    _roomReadEvents.add(id);
  }

  int? getUnreadCount(String roomId) {
    _clearForAnotherUser();
    final id = roomId.trim();
    if (id.isEmpty) return null;
    final index = _rooms.indexWhere(
      (r) => r.id.trim() == id || r.classroomId?.trim() == id,
    );
    return index != -1 ? _rooms[index].unreadCount : null;
  }

  void revertRoomRead(String roomId, int previousUnreadCount) {
    _clearForAnotherUser();
    final id = roomId.trim();
    if (id.isEmpty || previousUnreadCount <= 0) return;
    final index = _rooms.indexWhere(
      (r) => r.id.trim() == id || r.classroomId?.trim() == id,
    );
    if (index != -1) {
      final updated = List.of(_rooms);
      updated[index] = updated[index].copyWith(unreadCount: previousUnreadCount);
      _rooms = List.unmodifiable(updated);
      _roomsUpdateEvents.add(_rooms);
    }
  }

  void clear() {
    _rooms = const [];
    _ownerId = null;
    _roomsUpdateEvents.add(_rooms);
  }

  void _clearForAnotherUser() {
    if (_ownerId == _session.userId) return;
    _ownerId = _session.userId;
    _rooms = const [];
  }
}
