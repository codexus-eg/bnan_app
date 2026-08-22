import 'dart:async';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRoomMessagesCubit extends Cubit<GetRoomMessagesState> {
  GetRoomMessagesCubit(
    this.chatRepo,
    this.socketService, [
    this.notifications,
    this.roomsCache,
  ]) : super(GetRoomMessagesInitial());

  final ChatRepo chatRepo;
  final SocketService socketService;
  final ChatNotificationCoordinator? notifications;
  final ChatRoomsCache? roomsCache;

  final List<ChatMessageModel> _messages = [];
  final List<VoidCallback> _listenerDisposers = [];
  final Set<String> _arrivedDuringInitialLoadIds = {};

  String? _currentRoomId;
  String? _firstUnreadMessageId;
  String? _lastLocallyReadMessageId;
  DateTime? _previousLastOpenedAt;

  bool _initialHistoryResolved = false;

  Future<void> initializeChat({
    required String roomId,
  }) async {
    if (isClosed) return;

    final normalizedRoomId = roomId.trim();
    if (normalizedRoomId.isEmpty) return;

    _currentRoomId = normalizedRoomId;
    _firstUnreadMessageId = null;
    _lastLocallyReadMessageId = null;
    _initialHistoryResolved = false;
    _arrivedDuringInitialLoadIds.clear();

    _previousLastOpenedAt = _readLastOpened(normalizedRoomId);

    notifications?.enterRoom(normalizedRoomId);

    _messages.clear();

    try {
      await socketService.connect();
    } catch (error) {
      if (!isClosed) {
        emit(
          GetRoomMessagesFailure(
            errorMessage: error.toString(),
          ),
        );
      }
      return;
    }

    if (isClosed) return;

    _registerSocketListeners();

    socketService.joinRoom(normalizedRoomId);

    await getRoomMessages(
      roomId: normalizedRoomId,
    );
  }

  Future<void> getRoomMessages({
    required String roomId,
  }) async {
    if (isClosed) return;

    emit(GetRoomMessagesLoading());

    final result = await chatRepo.getRoomMessages(
      roomId: roomId,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          GetRoomMessagesFailure(
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        _mergeHistory(response.messages);

        if (!_initialHistoryResolved) {
          _initialHistoryResolved = true;

          _firstUnreadMessageId =
              _findFirstUnreadMessageId();
        }

        _emitMessages();
      },
    );
  }

  void _registerSocketListeners() {
    _removeSocketListeners();

    _listenerDisposers.addAll([
      socketService.listenToJoinedRoom((_) {}),
      socketService.listenToLeftRoom((_) {}),
      socketService.listenToNewMessage(_addMessage),
      socketService.listenToMessageEdited(_editMessage),
      socketService.listenToMessageDeleted(_deleteMessage),
      socketService.listenToReconnect(_rejoinCurrentRoom),
    ]);
  }

  void addConfirmedMessage(
    ChatMessageModel message,
  ) {
    _addMessage(message);
  }

  void _addMessage(ChatMessageModel message) {
    if (!_belongsToCurrentRoom(message)) return;

    if (!_initialHistoryResolved &&
        message.id.trim().isNotEmpty) {
      _arrivedDuringInitialLoadIds.add(
        message.id.trim(),
      );
    }

    _upsert(_messages, message);

    _emitMessages();

    if (_initialHistoryResolved) {
      _scheduleDebouncedMarkRead();
    }
  }

  void _scheduleDebouncedMarkRead() {
    _markReadDebounce?.cancel();
    _markReadDebounce = Timer(const Duration(milliseconds: 500), () {
      markCurrentRoomRead();
    });
  }

  void _editMessage(
    ChatMessageModel updatedMessage,
  ) {
    if (!_belongsToCurrentRoom(updatedMessage)) {
      return;
    }

    final messageIndex = _messages.indexWhere(
      (message) =>
          message.id == updatedMessage.id,
    );

    if (messageIndex == -1) return;

    _messages[messageIndex] = updatedMessage;

    _emitMessages();
  }

  void _deleteMessage(String messageId) {
    _markMessagesDeleted({messageId});
    _emitMessages();
  }

  Future<String?> deleteMessages({
    required String roomId,
    required Iterable<String> messageIds,
  }) async {
    final ids = messageIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .take(50)
        .toList(growable: false);

    if (ids.isEmpty) return null;

    final result = await chatRepo.deleteMessages(
      roomId: roomId,
      messageIds: ids,
    );

    if (isClosed) return null;

    return result.fold(
      (failure) => failure.message,
      (_) {
        _markMessagesDeleted(ids.toSet());
        _emitMessages();
        return null;
      },
    );
  }

  void _emitMessages() {
    if (isClosed) return;

    emit(
      GetRoomMessagesSuccess(
        messages:
            List<ChatMessageModel>.from(_messages),
        firstUnreadMessageId:
            _firstUnreadMessageId,
      ),
    );
  }

  void _markMessagesDeleted(
    Set<String> messageIds,
  ) {
    final ids =
        messageIds.map((id) => id.trim()).toSet();

    for (
      var index = 0;
      index < _messages.length;
      index++
    ) {
      final message = _messages[index];

      if (ids.contains(message.id.trim()) &&
          !message.deletedForEveryone) {
        _messages[index] =
            message.markDeleted();
      }
    }
  }

  String? _findFirstUnreadMessageId() {
    final lastOpened = _previousLastOpenedAt;

    if (lastOpened == null) return null;

    final currentUserId =
        SessionManager.instance.userId ?? '';

    for (final message in _messages) {
      final createdAt = message.createdAt;

      if (createdAt != null &&
          createdAt.isAfter(lastOpened) &&
          !message.deletedForEveryone &&
          !_arrivedDuringInitialLoadIds.contains(
            message.id.trim(),
          ) &&
          !message.isMine(currentUserId)) {
        return message.id;
      }
    }

    return null;
  }

  Timer? _markReadDebounce;

  void markCurrentRoomRead() {
    final roomId = _currentRoomId;

    if (roomId == null || isClosed) return;

    final latestMessageId = _messages.isEmpty
        ? null
        : _messages.last.id.trim();

    if (latestMessageId == null ||
        latestMessageId.isEmpty ||
        latestMessageId ==
            _lastLocallyReadMessageId) {
      return;
    }

    _lastLocallyReadMessageId =
        latestMessageId;

    unawaited(
      _sendMarkRoomAsRead(roomId),
    );

    // مهم:
    // لا نمسح firstUnreadMessageId هنا.
    // نحتفظ به طول فتح المحادثة حتى يظل
    // فاصل "رسائل جديدة" ظاهر في مكانه.
  }

  Future<void> _sendMarkRoomAsRead(String roomId) async {
    await chatRepo.markRoomAsRead(roomId: roomId);
    await _saveLatestMessageTimestamp(roomId);
    roomsCache?.markRoomRead(roomId);
  }

  DateTime? _readLastOpened(
    String roomId,
  ) {
    try {
      final value = CacheHelper.getData(
        key: _lastOpenedKey(roomId),
      );

      return DateTime.tryParse(
        value?.toString() ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveLatestMessageTimestamp(
    String roomId,
  ) async {
    final timestamps = _messages
        .map((message) => message.createdAt)
        .whereType<DateTime>();

    if (timestamps.isEmpty) return;

    final latest = timestamps.reduce(
      (a, b) => a.isAfter(b) ? a : b,
    );

    try {
      await CacheHelper.saveData(
        key: _lastOpenedKey(roomId),
        value:
            latest.toUtc().toIso8601String(),
      );
    } catch (_) {}
  }

  String _lastOpenedKey(String roomId) =>
      'chat_last_opened_'
      '${SessionManager.instance.userId ?? 'guest'}'
      '_$roomId';

  void _mergeHistory(
    List<ChatMessageModel> history,
  ) {
    final liveMessages =
        List<ChatMessageModel>.from(_messages);

    final merged = <ChatMessageModel>[];

    for (final message in history) {
      if (_belongsToCurrentRoom(message)) {
        _upsert(merged, message);
      }
    }

    for (final message in liveMessages) {
      if (_belongsToCurrentRoom(message)) {
        _upsert(merged, message);
      }
    }

    _messages
      ..clear()
      ..addAll(merged);
  }

  void _upsert(
    List<ChatMessageModel> messages,
    ChatMessageModel message,
  ) {
    final id = message.id.trim();

    final index = id.isEmpty
        ? -1
        : messages.indexWhere(
            (current) =>
                current.id.trim() == id,
          );

    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }

    _sortByCreatedAt(messages);
  }

  void _sortByCreatedAt(
    List<ChatMessageModel> messages,
  ) {
    final indexed =
        messages.indexed.toList();

    indexed.sort((left, right) {
      final leftDate = left.$2.createdAt;
      final rightDate = right.$2.createdAt;

      if (leftDate == null) {
        return rightDate == null
            ? left.$1.compareTo(right.$1)
            : 1;
      }

      if (rightDate == null) return -1;

      final byDate =
          leftDate.compareTo(rightDate);

      return byDate != 0
          ? byDate
          : left.$1.compareTo(right.$1);
    });

    messages
      ..clear()
      ..addAll(
        indexed.map((entry) => entry.$2),
      );
  }

  bool _belongsToCurrentRoom(
    ChatMessageModel message,
  ) {
    final messageRoomId =
        message.roomId.trim();

    return messageRoomId.isEmpty ||
        messageRoomId == _currentRoomId;
  }

  void _rejoinCurrentRoom() {
    final roomId = _currentRoomId;

    if (roomId != null &&
        roomId.isNotEmpty) {
      socketService.joinRoom(roomId);
    }
  }

  void _removeSocketListeners() {
    for (final disposeListener
        in _listenerDisposers) {
      disposeListener();
    }

    _listenerDisposers.clear();
  }

  @override
  Future<void> close() {
    _markReadDebounce?.cancel();
    final roomId = _currentRoomId;

    if (roomId != null) {
      socketService.leaveRoom(roomId);
      notifications?.leaveRoom(roomId);
    }

    _removeSocketListeners();

    return super.close();
  }
}