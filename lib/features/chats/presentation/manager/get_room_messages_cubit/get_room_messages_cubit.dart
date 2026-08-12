import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRoomMessagesCubit extends Cubit<GetRoomMessagesState> {
  GetRoomMessagesCubit(this.chatRepo, this.socketService)
    : super(GetRoomMessagesInitial());

  final ChatRepo chatRepo;
  final SocketService socketService;

  final List<ChatMessageModel> _messages = [];
  final List<VoidCallback> _listenerDisposers = [];

  String? _currentRoomId;

  Future<void> initializeChat({required String roomId}) async {
    final normalizedRoomId = roomId.trim();
    if (normalizedRoomId.isEmpty) return;

    _currentRoomId = normalizedRoomId;
    _messages.clear();

    try {
      await socketService.connect();
    } catch (error) {
      emit(GetRoomMessagesFailure(errorMessage: error.toString()));
      return;
    }

    _registerSocketListeners();
    socketService.joinRoom(normalizedRoomId);

    await getRoomMessages(roomId: normalizedRoomId);
  }

  Future<void> getRoomMessages({required String roomId}) async {
    emit(GetRoomMessagesLoading());

    final result = await chatRepo.getRoomMessages(roomId: roomId);

    result.fold(
      (failure) {
        emit(GetRoomMessagesFailure(errorMessage: failure.message));
      },
      (response) {
        _mergeHistory(response.messages);

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

  void addConfirmedMessage(ChatMessageModel message) => _addMessage(message);

  void _addMessage(ChatMessageModel message) {
    if (!_belongsToCurrentRoom(message)) return;

    _upsert(_messages, message);

    _emitMessages();
  }

  void _editMessage(ChatMessageModel updatedMessage) {
    if (!_belongsToCurrentRoom(updatedMessage)) return;

    final messageIndex = _messages.indexWhere(
      (message) => message.id == updatedMessage.id,
    );

    if (messageIndex == -1) return;

    _messages[messageIndex] = updatedMessage;

    _emitMessages();
  }

  void _deleteMessage(String messageId) {
    _messages.removeWhere((message) => message.id == messageId);

    _emitMessages();
  }

  void _emitMessages() {
    emit(
      GetRoomMessagesSuccess(messages: List<ChatMessageModel>.from(_messages)),
    );
  }

  void _mergeHistory(List<ChatMessageModel> history) {
    final liveMessages = List<ChatMessageModel>.from(_messages);
    final merged = <ChatMessageModel>[];

    for (final message in history) {
      if (_belongsToCurrentRoom(message)) _upsert(merged, message);
    }

    for (final message in liveMessages) {
      if (_belongsToCurrentRoom(message)) _upsert(merged, message);
    }

    _messages
      ..clear()
      ..addAll(merged);
  }

  void _upsert(List<ChatMessageModel> messages, ChatMessageModel message) {
    final id = message.id.trim();
    final index = id.isEmpty
        ? -1
        : messages.indexWhere((current) => current.id == id);

    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
  }

  bool _belongsToCurrentRoom(ChatMessageModel message) {
    final messageRoomId = message.roomId.trim();
    return messageRoomId.isEmpty || messageRoomId == _currentRoomId;
  }

  void _rejoinCurrentRoom() {
    final roomId = _currentRoomId;
    if (roomId != null && roomId.isNotEmpty) socketService.joinRoom(roomId);
  }

  void _removeSocketListeners() {
    for (final disposeListener in _listenerDisposers) {
      disposeListener();
    }
    _listenerDisposers.clear();
  }

  @override
  Future<void> close() {
    final roomId = _currentRoomId;

    if (roomId != null) {
      socketService.leaveRoom(roomId);
    }

    _removeSocketListeners();

    return super.close();
  }
}
