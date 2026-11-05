import 'dart:ui';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepo implements ChatRepo {
  List<ChatMessageModel> messages = [];
  bool markAsReadShouldFail = false;
  int markAsReadCalls = 0;
  String? lastMarkedRoomId;

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  }) async {
    return Right(
      ChatMessagesResponseModel(
        success: true,
        results: messages.length,
        messages: List.of(messages),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRoomAsRead({required String roomId}) async {
    markAsReadCalls++;
    lastMarkedRoomId = roomId;
    if (markAsReadShouldFail) {
      return Left(Failure(message: 'Network error', statusCode: 500));
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async {
    return const Right(
      ChatRoomsResponseModel(
        success: true,
        results: 1,
        rooms: [
          ChatRoomSummaryModel(
            id: 'room-1',
            type: 'shared_group',
            displayName: 'أول ابتدائي - مشترك',
            subtitle: '',
            unreadCount: 12,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSocketService extends SocketService {
  @override
  Future<void> connect() async {}

  @override
  void joinRoom(String roomId) {}

  @override
  void leaveRoom(String roomId) {}

  @override
  VoidCallback listenToJoinedRoom(void Function(String roomId) onJoined) => () {};

  @override
  VoidCallback listenToLeftRoom(void Function(String roomId) onLeft) => () {};

  @override
  VoidCallback listenToNewMessage(void Function(ChatMessageModel message) onNewMessage) => () {};

  @override
  VoidCallback listenToMessageEdited(void Function(ChatMessageModel message) onMessageEdited) => () {};

  @override
  VoidCallback listenToMessageDeleted(void Function(String messageId) onMessageDeleted) => () {};

  @override
  VoidCallback listenToReconnect(VoidCallback onReconnect) => () {};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Classroom Unread Message Counter Regression Tests', () {
    test('ChatRoomSummaryModel parses unreadCount safely', () {
      expect(ChatRoomSummaryModel.parseUnreadCount(12), 12);
      expect(ChatRoomSummaryModel.parseUnreadCount('12'), 12);
      expect(ChatRoomSummaryModel.parseUnreadCount(12.5), 12);
      expect(ChatRoomSummaryModel.parseUnreadCount(-5), 0);
      expect(ChatRoomSummaryModel.parseUnreadCount(null), 0);
      expect(ChatRoomSummaryModel.parseUnreadCount('invalid'), 0);
    });

    test('Opening empty conversation with unread count 12 sends markRoomAsRead and zeroes cache', () async {
      final repo = _FakeChatRepo();
      final socket = _FakeSocketService();
      final cache = ChatRoomsCache(SessionManager.instance);
      cache.replace([
        const ChatRoomSummaryModel(
          id: 'room-1',
          type: 'shared_group',
          displayName: 'أول ابتدائي - مشترك',
          subtitle: '',
          unreadCount: 12,
        ),
      ]);

      final cubit = GetRoomMessagesCubit(
        repo,
        socket,
        null,
        cache,
      );

      await cubit.initializeChat(roomId: 'room-1');

      expect(repo.markAsReadCalls, 1);
      expect(repo.lastMarkedRoomId, 'room-1');
      expect(cache.find('room-1')?.unreadCount, 0);

      await cubit.close();
    });

    test('Opening conversation containing only session events marks room as read', () async {
      final repo = _FakeChatRepo();
      final socket = _FakeSocketService();
      repo.messages = [
        ChatMessageModel(
          id: 'msg-event-1',
          roomId: 'room-1',
          sender: const ChatSenderModel(id: 's1', fullName: 'System', role: 'admin'),
          text: 'Session summary report',
          attachments: const [],
          messageType: 'session_report',
          deletedForEveryone: false,
          createdAt: DateTime.now(),
        ),
      ];

      final cache = ChatRoomsCache(SessionManager.instance);
      cache.replace([
        const ChatRoomSummaryModel(
          id: 'room-1',
          type: 'shared_group',
          displayName: 'أول ابتدائي - مشترك',
          subtitle: '',
          unreadCount: 12,
        ),
      ]);

      final cubit = GetRoomMessagesCubit(
        repo,
        socket,
        null,
        cache,
      );

      await cubit.initializeChat(roomId: 'room-1');

      expect(repo.markAsReadCalls, 1);
      expect(cache.find('room-1')?.unreadCount, 0);

      await cubit.close();
    });

    test('Non-displayable session events do not trigger unread increment', () {
      final sessionMsg = ChatMessageModel(
        id: 'evt-1',
        roomId: 'room-1',
        sender: const ChatSenderModel(id: 's1', fullName: 'Bot', role: 'system'),
        text: 'Session report',
        attachments: const [],
        messageType: 'session_report',
        deletedForEveryone: false,
        createdAt: DateTime.now(),
      );

      final event = ChatNotificationEvent.fromMessage(sessionMsg);

      expect(event.isDisplayable, isFalse);
    });

    test('Rolls back optimistic read count if server markRoomAsRead fails', () async {
      final repo = _FakeChatRepo()..markAsReadShouldFail = true;
      final socket = _FakeSocketService();
      final cache = ChatRoomsCache(SessionManager.instance);
      cache.replace([
        const ChatRoomSummaryModel(
          id: 'room-1',
          type: 'shared_group',
          displayName: 'أول ابتدائي - مشترك',
          subtitle: '',
          unreadCount: 12,
        ),
      ]);

      final roomsCubit = GetChatRoomsCubit(repo, null, cache);
      final messagesCubit = GetRoomMessagesCubit(
        repo,
        socket,
        null,
        cache,
      );

      await messagesCubit.initializeChat(roomId: 'room-1');
      await pumpEventQueue();

      // Optimistic update was reverted back to 12 upon error
      expect(cache.find('room-1')?.unreadCount, 12);
      expect(roomsCubit.totalUnreadCount, 12);

      await messagesCubit.close();
      await roomsCubit.close();
    });

    test('Switching user account clears chat rooms cache and unread count', () async {
      final repo = _FakeChatRepo();
      final cache = ChatRoomsCache(SessionManager.instance);
      cache.replace([
        const ChatRoomSummaryModel(
          id: 'room-1',
          type: 'shared_group',
          displayName: 'Room 1',
          subtitle: '',
          unreadCount: 12,
        ),
      ]);

      final cubit = GetChatRoomsCubit(repo, null, cache);
      expect(cubit.totalUnreadCount, 12);

      // Verify clear resets cache and rooms
      cache.clear();
      expect(cache.rooms, isEmpty);

      await cubit.close();
    });
  });
}
