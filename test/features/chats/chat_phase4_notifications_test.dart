import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'incoming outside current room alerts once and deduplicates id',
    () async {
      final alert = _Alert();
      final coordinator = ChatNotificationCoordinator(
        _Socket(),
        alert: alert,
        currentUserId: () => 'me',
      );
      final foreground = <String>[];
      final subscription = coordinator.foregroundEvents.listen(
        (event) => foreground.add(event.messageId),
      );

      coordinator.handleMessage(_message('m1', senderId: 'other'));
      coordinator.handleMessage(_message('m1', senderId: 'other'));
      await Future<void>.delayed(Duration.zero);

      expect(alert.calls, 1);
      expect(foreground, ['m1']);
      await subscription.cancel();
      await coordinator.dispose();
    },
  );

  test('own echo and current room do not alert', () async {
    final alert = _Alert();
    final coordinator = ChatNotificationCoordinator(
      _Socket(),
      alert: alert,
      currentUserId: () => 'me',
    );
    coordinator.enterRoom('room-1');

    coordinator.handleMessage(_message('own', senderId: 'me'));
    coordinator.handleMessage(_message('current', senderId: 'other'));
    await Future<void>.delayed(Duration.zero);

    expect(alert.calls, 0);
    await coordinator.dispose();
  });

  test('room list updates last message and moves room to top', () async {
    final coordinator = ChatNotificationCoordinator(
      _Socket(),
      alert: _Alert(),
      currentUserId: () => 'me',
    );
    final cubit = GetChatRoomsCubit(_RoomsRepo(), coordinator);
    await cubit.getChatRooms();

    coordinator.handleMessage(
      _message('m2', roomId: 'room-2', senderId: 'other', text: 'latest'),
    );
    await Future<void>.delayed(Duration.zero);

    final rooms = (cubit.state as GetChatRoomsSuccess).rooms;
    expect(rooms.map((room) => room.id), ['room-2', 'room-1']);
    expect(rooms.first.lastMessage, 'latest');
    expect(rooms.first.lastMessageAt, isNotNull);
    await cubit.close();
    await coordinator.dispose();
  });

  test('notification payload routing is safe and parses nested ids', () async {
    final alert = _Alert();
    final coordinator = ChatNotificationCoordinator(
      _Socket(),
      alert: alert,
      currentUserId: () => 'me',
    );
    final roomIds = <String>[];
    final subscription = coordinator.foregroundEvents.listen(
      (event) => roomIds.add(event.roomId),
    );

    coordinator.handleNotification({
      'key': 'chat-message',
      'resource': {'id': 'message-id', 'model': 'Message'},
      'data': {
        'room': {'_id': 'room/id'},
        'sender': {'id': 'other'},
        'message': 'Hello',
      },
    });
    coordinator.handleNotification({'data': <String, dynamic>{}});
    await Future<void>.delayed(Duration.zero);

    expect(roomIds, ['room/id']);
    expect(ChatNotificationRoute.path('room/id'), '/chat/room%2Fid');
    expect(ChatNotificationRoute.path('  '), isNull);
    expect(ChatNotificationRoute.path(null), isNull);
    await subscription.cancel();
    await coordinator.dispose();
  });

  test('stop cleans scoped listeners and disconnects old session', () async {
    final socket = _Socket();
    final coordinator = ChatNotificationCoordinator(
      socket,
      alert: _Alert(),
      currentUserId: () => 'me',
    );

    await coordinator.start();
    expect(coordinator.listenerCount, 2);
    coordinator.stop(disconnect: true);

    expect(coordinator.listenerCount, 0);
    expect(socket.disposedListeners, 2);
    expect(socket.disconnects, 1);
    await coordinator.dispose();
  });
}

ChatMessageModel _message(
  String id, {
  String roomId = 'room-1',
  required String senderId,
  String text = 'message',
}) {
  return ChatMessageModel(
    id: id,
    roomId: roomId,
    sender: ChatSenderModel(id: senderId, fullName: 'Sender', role: 'student'),
    text: text,
    attachments: const <ChatAttachmentModel>[],
    messageType: 'text',
    deletedForEveryone: false,
    createdAt: DateTime.utc(2026),
  );
}

class _Alert implements ChatForegroundAlert {
  int calls = 0;

  @override
  Future<void> play() async => calls++;
}

class _Socket extends SocketService {
  int disposedListeners = 0;
  int disconnects = 0;

  @override
  Future<void> connect() async {}

  VoidCallback _dispose() =>
      () => disposedListeners++;

  @override
  VoidCallback listenToNewMessage(
    void Function(ChatMessageModel message) onNewMessage,
  ) => _dispose();

  @override
  VoidCallback listenToNotification(
    void Function(Map<String, dynamic> notification) onNotification,
  ) => _dispose();

  @override
  void disconnect() => disconnects++;
}

class _RoomsRepo implements ChatRepo {
  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async {
    return const Right(
      ChatRoomsResponseModel(
        success: true,
        results: 2,
        rooms: [
          ChatRoomSummaryModel(
            id: 'room-1',
            type: 'support',
            displayName: 'One',
            subtitle: '',
          ),
          ChatRoomSummaryModel(
            id: 'room-2',
            type: 'support',
            displayName: 'Two',
            subtitle: '',
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  }) async => const Right(
    ChatMessagesResponseModel(success: true, results: 0, messages: []),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
