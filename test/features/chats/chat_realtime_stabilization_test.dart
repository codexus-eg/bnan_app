import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chat realtime stabilization', () {
    test(
      'first open awaits connection before listeners and room join',
      () async {
        final socket = _FakeSocketService(connectGate: Completer<void>());
        final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);

        final initialization = cubit.initializeChat(roomId: 'room-1');
        await Future<void>.delayed(Duration.zero);

        expect(socket.events, ['connect:start']);

        socket.connectGate!.complete();
        await initialization;

        expect(
          socket.events,
          containsAllInOrder(['connect:done', 'listen:new', 'join:room-1']),
        );

        socket.emitNewMessage(_message('live-1'));
        expect(_messages(cubit).map((message) => message.id), ['live-1']);

        await cubit.close();
      },
    );

    test('reconnect rejoins the current room', () async {
      final socket = _FakeSocketService();
      final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);

      await cubit.initializeChat(roomId: 'room-1');
      socket.emitReconnect();

      expect(socket.events.where((event) => event == 'join:room-1').length, 2);

      await cubit.close();
    });

    test(
      'HTTP confirmation is visible and socket echo is deduplicated',
      () async {
        final socket = _FakeSocketService();
        final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);
        final confirmed = _message('message-1');

        await cubit.initializeChat(roomId: 'room-1');
        cubit.addConfirmedMessage(confirmed);
        socket.emitNewMessage(confirmed);

        expect(_messages(cubit), hasLength(1));
        expect(_messages(cubit).single.id, 'message-1');

        await cubit.close();
      },
    );

    test(
      'REST and Socket messages with the same normalized id merge',
      () async {
        final repo = _FakeChatRepo(
          response: _response([_message('message-1 ')]),
        );
        final socket = _FakeSocketService();
        final cubit = GetRoomMessagesCubit(repo, socket);

        await cubit.initializeChat(roomId: 'room-1');
        socket.emitNewMessage(_message('message-1'));

        expect(_messages(cubit), hasLength(1));
        expect(_messages(cubit).single.id, 'message-1');

        await cubit.close();
      },
    );

    test('live message is retained when history completes later', () async {
      final history = Completer<Either<Failure, ChatMessagesResponseModel>>();
      final repo = _FakeChatRepo(history: history);
      final socket = _FakeSocketService();
      final cubit = GetRoomMessagesCubit(repo, socket);

      final initialization = cubit.initializeChat(roomId: 'room-1');
      await Future<void>.delayed(Duration.zero);
      socket.emitNewMessage(_message('live-1'));
      history.complete(Right(_response([_message('history-1')])));
      await initialization;

      expect(_messages(cubit).map((message) => message.id), [
        'history-1',
        'live-1',
      ]);

      await cubit.close();
    });

    test('message from another room is ignored', () async {
      final socket = _FakeSocketService();
      final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);

      await cubit.initializeChat(roomId: 'room-1');
      socket.emitNewMessage(_message('other-1', roomId: 'room-2'));

      expect(_messages(cubit), isEmpty);

      await cubit.close();
    });

    test('messages stay ordered by createdAt after live upserts', () async {
      final socket = _FakeSocketService();
      final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);
      await cubit.initializeChat(roomId: 'room-1');

      socket.emitNewMessage(_message('later', minute: 2));
      socket.emitNewMessage(_message('earlier', minute: 1));

      expect(_messages(cubit).map((message) => message.id), [
        'earlier',
        'later',
      ]);
      await cubit.close();
    });

    test('dispose removes only registered callbacks and leaves room', () async {
      final socket = _FakeSocketService();
      final cubit = GetRoomMessagesCubit(_FakeChatRepo(), socket);

      await cubit.initializeChat(roomId: 'room-1');
      await cubit.close();

      expect(socket.disposedListeners, 6);
      expect(socket.events, contains('leave:room-1'));
    });
  });

  test('message model reads a populated room id', () {
    final message = ChatMessageModel.fromJson({
      'id': 'message-1',
      'room': {'_id': 'room-1'},
      'sender': <String, dynamic>{},
    });

    expect(message.roomId, 'room-1');
    expect(
      ChatMessageModel.fromJson({
        'id': 'message-2',
        'roomId': 'room-2',
        'sender': <String, dynamic>{},
      }).roomId,
      'room-2',
    );
  });

  test('message and sender parse backend _id and fullName', () {
    final message = ChatMessageModel.fromJson({
      '_id': 'message-1',
      'room': 'room-1',
      'sender': {'_id': 'sender-1', 'fullName': 'Ahmed', 'role': 'teacher'},
    });

    expect(message.id, 'message-1');
    expect(message.sender.id, 'sender-1');
    expect(message.sender.fullName, 'Ahmed');
  });
}

List<ChatMessageModel> _messages(GetRoomMessagesCubit cubit) {
  return (cubit.state as GetRoomMessagesSuccess).messages;
}

ChatMessageModel _message(
  String id, {
  String roomId = 'room-1',
  int minute = 0,
}) {
  return ChatMessageModel(
    id: id,
    roomId: roomId,
    sender: const ChatSenderModel(
      id: 'sender-1',
      fullName: 'Sender',
      role: 'student',
    ),
    text: id,
    attachments: const [],
    messageType: 'text',
    deletedForEveryone: false,
    createdAt: DateTime.utc(2026).add(Duration(minutes: minute)),
  );
}

ChatMessagesResponseModel _response(List<ChatMessageModel> messages) {
  return ChatMessagesResponseModel(
    success: true,
    results: messages.length,
    messages: messages,
  );
}

class _FakeChatRepo implements ChatRepo {
  _FakeChatRepo({this.history, this.response});

  final Completer<Either<Failure, ChatMessagesResponseModel>>? history;
  final ChatMessagesResponseModel? response;

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  }) async {
    return history?.future ?? Right(response ?? _response([]));
  }

  @override
  Future<Either<Failure, void>> markRoomAsRead({required String roomId}) async {
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSocketService extends SocketService {
  _FakeSocketService({this.connectGate});

  final Completer<void>? connectGate;
  final List<String> events = [];
  int disposedListeners = 0;
  void Function(ChatMessageModel message)? _onNewMessage;
  VoidCallback? _onReconnect;

  @override
  Future<void> connect() async {
    events.add('connect:start');
    await connectGate?.future;
    events.add('connect:done');
  }

  @override
  void joinRoom(String roomId) => events.add('join:$roomId');

  @override
  void leaveRoom(String roomId) => events.add('leave:$roomId');

  VoidCallback _listen(String event) {
    events.add('listen:$event');
    return () => disposedListeners++;
  }

  @override
  VoidCallback listenToJoinedRoom(void Function(String roomId) onJoined) {
    return _listen('joined');
  }

  @override
  VoidCallback listenToLeftRoom(void Function(String roomId) onLeft) {
    return _listen('left');
  }

  @override
  VoidCallback listenToNewMessage(
    void Function(ChatMessageModel message) onNewMessage,
  ) {
    _onNewMessage = onNewMessage;
    return _listen('new');
  }

  @override
  VoidCallback listenToMessageEdited(
    void Function(ChatMessageModel message) onMessageEdited,
  ) {
    return _listen('edited');
  }

  @override
  VoidCallback listenToMessageDeleted(
    void Function(String messageId) onMessageDeleted,
  ) {
    return _listen('deleted');
  }

  @override
  VoidCallback listenToReconnect(VoidCallback onReconnect) {
    _onReconnect = onReconnect;
    return _listen('reconnect');
  }

  void emitNewMessage(ChatMessageModel message) => _onNewMessage?.call(message);

  void emitReconnect() => _onReconnect?.call();
}
