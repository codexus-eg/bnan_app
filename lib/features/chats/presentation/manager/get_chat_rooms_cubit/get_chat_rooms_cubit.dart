import 'dart:async';

import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetChatRoomsCubit extends Cubit<GetChatRoomsState> {
  GetChatRoomsCubit(this.chatRepo, [this.notifications, this.roomsCache])
    : super(GetChatRoomsInitial()) {
    if (roomsCache != null && roomsCache!.rooms.isNotEmpty) {
      _allRooms = roomsCache!.rooms;
      emit(GetChatRoomsSuccess(rooms: _visibleRooms));
    }
    _notificationSubscription = notifications?.roomEvents.listen(_updateRoom);
    _roomReadSubscription = roomsCache?.roomReadEvents.listen(markRoomRead);
    _roomsUpdateSubscription =
        roomsCache?.roomsUpdateEvents.listen(_onRoomsCacheUpdated);
    SessionManager.instance.addSessionChangeListener(_onSessionChanged);
  }

  final ChatRepo chatRepo;
  final ChatNotificationCoordinator? notifications;
  final ChatRoomsCache? roomsCache;
  final Set<String> _processedMessageIds = {};
  StreamSubscription<ChatNotificationEvent>? _notificationSubscription;
  StreamSubscription<String>? _roomReadSubscription;
  StreamSubscription<List<ChatRoomSummaryModel>>? _roomsUpdateSubscription;
  Timer? _searchDebounce;
  String _adminSearch = '';
  String _roomSearch = '';
  List<ChatRoomSummaryModel> _allRooms = const [];
  int _requestId = 0;

  Future<void> _onSessionChanged(String? prev, String? next) async {
    if (prev != next) {
      _allRooms = const [];
      _processedMessageIds.clear();
      if (next?.trim().isNotEmpty == true) {
        unawaited(getChatRooms());
      } else {
        emit(GetChatRoomsSuccess(rooms: const []));
      }
    }
  }

  int get totalUnreadCount =>
      _allRooms.fold(0, (total, room) => total + room.unreadCount);

  void _onRoomsCacheUpdated(List<ChatRoomSummaryModel> cached) {
    if (isClosed || identical(_allRooms, cached)) return;
    _allRooms = cached;
    emit(GetChatRoomsSuccess(rooms: _visibleRooms));
  }

  Future<void> getChatRooms() async {
    if (isClosed) return;
    final requestId = ++_requestId;
    if (_allRooms.isEmpty) {
      emit(GetChatRoomsLoading());
    }

    final result = SessionManager.instance.role == UserRole.admin
        ? await chatRepo.getAdminChatRooms(search: _adminSearch)
        : await chatRepo.getChatRooms();
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) {
        if (_allRooms.isEmpty) {
          emit(GetChatRoomsFailure(errorMessage: failure.message));
        }
      },
      (response) {
        _allRooms = response.rooms;
        roomsCache?.replace(response.rooms);
        emit(GetChatRoomsSuccess(rooms: _visibleRooms));
      },
    );
  }

  void searchRooms(String value) {
    if (SessionManager.instance.role == UserRole.admin) {
      searchAdminRooms(value);
      return;
    }
    if (SessionManager.instance.role != UserRole.supervisor &&
        SessionManager.instance.role != UserRole.teacher) {
      return;
    }
    _roomSearch = value.trim().toLowerCase();
    emit(GetChatRoomsSuccess(rooms: _visibleRooms));
  }

  List<ChatRoomSummaryModel> get _visibleRooms {
    if (_roomSearch.isEmpty) return _allRooms;
    return _allRooms.where((room) {
      final value = '${room.displayName} ${room.subtitle}'.toLowerCase();
      return value.contains(_roomSearch);
    }).toList();
  }

  void searchAdminRooms(String value) {
    if (SessionManager.instance.role != UserRole.admin) return;
    _adminSearch = value.trim();
    _searchDebounce?.cancel();
    if (_adminSearch.isEmpty) {
      unawaited(getChatRooms());
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () => unawaited(getChatRooms()),
    );
  }

  void markRoomRead(String roomId) {
    if (isClosed) return;
    final id = roomId.trim();
    if (id.isEmpty) return;
    final index = _allRooms.indexWhere(
      (room) => room.id.trim() == id || room.classroomId?.trim() == id,
    );
    if (index == -1) return;
    if (_allRooms[index].unreadCount == 0) return;
    final rooms = List.of(_allRooms);
    rooms[index] = rooms[index].copyWith(unreadCount: 0);
    _allRooms = rooms;
    roomsCache?.replace(rooms);
    emit(GetChatRoomsSuccess(rooms: _visibleRooms));
  }

  void revertRoomRead(String roomId, int previousUnreadCount) {
    if (isClosed) return;
    final id = roomId.trim();
    if (id.isEmpty || previousUnreadCount <= 0) return;
    final index = _allRooms.indexWhere(
      (room) => room.id.trim() == id || room.classroomId?.trim() == id,
    );
    if (index == -1) return;
    final rooms = List.of(_allRooms);
    rooms[index] = rooms[index].copyWith(unreadCount: previousUnreadCount);
    _allRooms = rooms;
    roomsCache?.replace(rooms);
    emit(GetChatRoomsSuccess(rooms: _visibleRooms));
  }

  void _updateRoom(ChatNotificationEvent event) {
    if (isClosed) return;
    final roomId = event.roomId.trim();
    if (roomId.isEmpty || event.message.isEmpty) {
      unawaited(getChatRooms());
      return;
    }

    final index = _allRooms.indexWhere(
      (room) => room.id.trim() == roomId || room.classroomId?.trim() == roomId,
    );
    if (index == -1) {
      unawaited(getChatRooms());
      return;
    }

    final currentUserId = SessionManager.instance.userId?.trim() ?? '';
    final isMine = event.senderId.isNotEmpty && event.senderId == currentUserId;
    final isCurrentRoom =
        notifications?.currentRoomId == roomId ||
        notifications?.currentRoomId == _allRooms[index].id;

    final messageId = event.messageId.trim();
    final isDuplicate =
        messageId.isNotEmpty && !_processedMessageIds.add(messageId);
    if (_processedMessageIds.length > 500) {
      _processedMessageIds.remove(_processedMessageIds.first);
    }

    final shouldIncrement =
        event.isDisplayable && !isMine && !isCurrentRoom && !isDuplicate;

    final rooms = List.of(_allRooms);
    final prev = rooms.removeAt(index);
    final updated = prev.copyWith(
      lastMessage: event.message.isNotEmpty ? event.message : prev.lastMessage,
      lastMessageAt: event.createdAt,
      unreadCount: shouldIncrement ? prev.unreadCount + 1 : prev.unreadCount,
    );
    rooms.insert(0, updated);
    _allRooms = rooms;
    roomsCache?.replace(rooms);
    emit(GetChatRoomsSuccess(rooms: _visibleRooms));
  }

  @override
  Future<void> close() async {
    _searchDebounce?.cancel();
    await _notificationSubscription?.cancel();
    await _roomReadSubscription?.cancel();
    await _roomsUpdateSubscription?.cancel();
    SessionManager.instance.removeSessionChangeListener(_onSessionChanged);
    return super.close();
  }
}
