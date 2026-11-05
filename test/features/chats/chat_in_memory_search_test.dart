import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('In-Memory Chat Search', () {
    late _FakeChatRepo repo;
    late _FakeSocketService socket;
    late GetRoomMessagesCubit cubit;

    setUp(() {
      repo = _FakeChatRepo();
      socket = _FakeSocketService();
      cubit = GetRoomMessagesCubit(repo, socket);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('searches English case-insensitively and Arabic correctly', () async {
      repo.messages = [
        _message('1', 'Hello World', createdAt: DateTime(2026, 1, 1, 10, 0)),
        _message(
          '2',
          'مرحبا بك في تطبيق بنان',
          createdAt: DateTime(2026, 1, 1, 10, 1),
        ),
        _message(
          '3',
          'Another hello message',
          createdAt: DateTime(2026, 1, 1, 10, 2),
        ),
      ];

      await cubit.initializeChat(roomId: 'room-1');
      cubit.openSearch();

      expect(cubit.search.isSearching, isTrue);

      // Search English
      cubit.updateSearchQuery('hello');
      expect(cubit.search.resultMessageIds, ['1', '3']);
      expect(cubit.search.currentIndex, 0);
      expect(cubit.search.targetMessageId, '1');

      // Next / Previous navigation
      cubit.nextSearchResult();
      expect(cubit.search.currentIndex, 1);
      expect(cubit.search.targetMessageId, '3');

      cubit.nextSearchResult(); // wraps to 0
      expect(cubit.search.currentIndex, 0);
      expect(cubit.search.targetMessageId, '1');

      cubit.previousSearchResult(); // wraps to 1
      expect(cubit.search.currentIndex, 1);
      expect(cubit.search.targetMessageId, '3');

      // Search Arabic
      cubit.updateSearchQuery('بنان');
      expect(cubit.search.resultMessageIds, ['2']);
      expect(cubit.search.currentIndex, 0);
      expect(cubit.search.targetMessageId, '2');

      // Empty query clears results
      cubit.updateSearchQuery('   ');
      expect(cubit.search.resultMessageIds, isEmpty);
      expect(cubit.search.currentIndex, -1);

      // Close search
      cubit.closeSearch();
      expect(cubit.search.isSearching, isFalse);
    });

    test('ignores deleted messages and non-displayable messages', () async {
      repo.messages = [
        _message('1', 'Test message', deleted: true),
        _message('2', 'Test message', messageType: 'session_report'),
        _message('3', 'Test message'),
      ];

      await cubit.initializeChat(roomId: 'room-1');
      cubit.openSearch();
      cubit.updateSearchQuery('test');

      expect(cubit.search.resultMessageIds, ['3']);
    });

    test(
      'realtime new message and deleted message update search dynamically',
      () async {
        repo.messages = [_message('1', 'Important update')];

        await cubit.initializeChat(roomId: 'room-1');
        cubit.openSearch();
        cubit.updateSearchQuery('update');
        expect(cubit.search.resultMessageIds, ['1']);

        // Live message arrives
        socket.emitNewMessage(
          _message('2', 'Another update message', createdAt: DateTime.now()),
        );
        expect(cubit.search.resultMessageIds, ['1', '2']);

        // Delete message
        socket.emitMessageDeleted('1');
        expect(cubit.search.resultMessageIds, ['2']);
        expect(cubit.search.targetMessageId, '2');
      },
    );
  });
}

ChatMessageModel _message(
  String id,
  String text, {
  DateTime? createdAt,
  bool deleted = false,
  String messageType = 'text',
}) {
  return ChatMessageModel(
    id: id,
    roomId: 'room-1',
    sender: const ChatSenderModel(
      id: 'sender-1',
      fullName: 'User',
      role: 'teacher',
    ),
    text: text,
    attachments: const [],
    messageType: messageType,
    createdAt: createdAt ?? DateTime.now(),
    deletedForEveryone: deleted,
  );
}

class _FakeChatRepo implements ChatRepo {
  List<ChatMessageModel> messages = [];

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  }) async {
    return Right(
      ChatMessagesResponseModel(
        success: true,
        results: messages.length,
        messages: messages,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRoomAsRead({required String roomId}) async {
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSocketService implements SocketService {
  void Function(ChatMessageModel)? onNewMessage;
  void Function(String)? onMessageDeleted;

  @override
  Future<void> connect() async {}

  @override
  void joinRoom(String roomId) {}

  @override
  void leaveRoom(String roomId) {}

  @override
  VoidCallback listenToJoinedRoom(void Function(String) listener) => () {};

  @override
  VoidCallback listenToLeftRoom(void Function(String) listener) => () {};

  @override
  VoidCallback listenToNewMessage(void Function(ChatMessageModel) listener) {
    onNewMessage = listener;
    return () {};
  }

  @override
  VoidCallback listenToMessageEdited(
    void Function(ChatMessageModel) listener,
  ) => () {};

  @override
  VoidCallback listenToMessageDeleted(void Function(String) listener) {
    onMessageDeleted = listener;
    return () {};
  }

  @override
  VoidCallback listenToReconnect(VoidCallback listener) => () {};

  void emitNewMessage(ChatMessageModel message) => onNewMessage?.call(message);
  void emitMessageDeleted(String id) => onMessageDeleted?.call(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
