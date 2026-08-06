import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRoomMessagesCubit extends Cubit<GetRoomMessagesState> {
  GetRoomMessagesCubit(this.chatRepo, this.socketService)
    : super(GetRoomMessagesInitial());

  final ChatRepo chatRepo;
  final SocketService socketService;

  final List<ChatMessageModel> _messages = [];

  String? _currentRoomId;

  Future<void> initializeChat({required String roomId}) async {
    _currentRoomId = roomId;

    _registerSocketListeners();

    await socketService.connect();

    socketService.joinRoom(roomId);

    await getRoomMessages(roomId: roomId);
  }

  Future<void> getRoomMessages({required String roomId}) async {
    emit(GetRoomMessagesLoading());

    final result = await chatRepo.getRoomMessages(roomId: roomId);

    result.fold(
      (failure) {
        emit(GetRoomMessagesFailure(errorMessage: failure.message));
      },
      (response) {
        _messages
          ..clear()
          ..addAll(response.messages);

        _emitMessages();
      },
    );
  }

  void _registerSocketListeners() {
    socketService.listenToJoinedRoom((roomId) {
      print('Joined room: $roomId');
    });

    socketService.listenToLeftRoom((roomId) {
      print('Left room: $roomId');
    });

    socketService.listenToNewMessage((message) {
      _addMessage(message);
    });

    socketService.listenToMessageEdited((message) {
      _editMessage(message);
    });

    socketService.listenToMessageDeleted((messageId) {
      _deleteMessage(messageId);
    });
  }

  void _addMessage(ChatMessageModel message) {
    final alreadyExists = _messages.any(
      (currentMessage) => currentMessage.id == message.id,
    );

    if (alreadyExists) return;

    _messages.add(message);

    _emitMessages();
  }

  void _editMessage(ChatMessageModel updatedMessage) {
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

  @override
  Future<void> close() {
    final roomId = _currentRoomId;

    if (roomId != null) {
      socketService.leaveRoom(roomId);
    }

    socketService.removeChatListeners();

    return super.close();
  }
}
