import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/policies/chat_message_delete_policy.dart';
import 'package:bnan_app/features/chats/presentation/policies/chat_message_edit_policy.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  group('ChatMessageEditPolicy', () {
    test('author can edit their own active message', () {
      final msg = _message('m1', 'Hello', senderId: 'user-1');
      expect(
        ChatMessageEditPolicy.canEdit(message: msg, currentUserId: 'user-1'),
        isTrue,
      );
    });

    test('user cannot edit another user message', () {
      final msg = _message('m1', 'Hello', senderId: 'user-2');
      expect(
        ChatMessageEditPolicy.canEdit(message: msg, currentUserId: 'user-1'),
        isFalse,
      );
    });

    test('cannot edit deleted message', () {
      final msg = _message(
        'm1',
        'Hello',
        senderId: 'user-1',
        deletedForEveryone: true,
      );
      expect(
        ChatMessageEditPolicy.canEdit(message: msg, currentUserId: 'user-1'),
        isFalse,
      );
    });

    test('cannot edit session event message', () {
      final msg = _message(
        'm1',
        'Session report',
        senderId: 'user-1',
        messageType: 'session_report',
      );
      expect(
        ChatMessageEditPolicy.canEdit(message: msg, currentUserId: 'user-1'),
        isFalse,
      );
    });
  });

  group('ChatMessageDeletePolicy', () {
    test('owner can delete their own message', () {
      final msg = _message(
        'm1',
        'Hi',
        senderId: 'student-1',
        senderRole: 'student',
      );
      expect(
        ChatMessageDeletePolicy.canDelete(
          message: msg,
          currentUserRole: 'student',
          currentUserId: 'student-1',
        ),
        isTrue,
      );
    });

    test('student cannot delete another message', () {
      final msg = _message(
        'm1',
        'Hi',
        senderId: 'student-2',
        senderRole: 'student',
      );
      expect(
        ChatMessageDeletePolicy.canDelete(
          message: msg,
          currentUserRole: 'student',
          currentUserId: 'student-1',
        ),
        isFalse,
      );
    });

    test('admin can delete any message', () {
      final msg = _message('m1', 'Hi', senderId: 'user-2', senderRole: 'teacher');
      expect(
        ChatMessageDeletePolicy.canDelete(
          message: msg,
          currentUserRole: 'admin',
          currentUserId: 'admin-1',
        ),
        isTrue,
      );
    });

    test('supervisor cannot delete admin message', () {
      final msg = _message('m1', 'Hi', senderId: 'admin-1', senderRole: 'admin');
      expect(
        ChatMessageDeletePolicy.canDelete(
          message: msg,
          currentUserRole: 'supervisor',
          currentUserId: 'sup-1',
        ),
        isFalse,
      );
    });
  });

  group('GetRoomMessagesCubit Edit & Delete', () {
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

    test('editMessage updates local message on success', () async {
      repo.messages = [
        _message('m1', 'Original text', roomId: 'r1', senderId: 'u1'),
      ];
      await cubit.initializeChat(roomId: 'r1');

      final error = await cubit.editMessage(
        messageId: 'm1',
        text: 'Updated text',
      );
      expect(error, isNull);
      expect(repo.lastEditedId, 'm1');
      expect(repo.lastEditedText, 'Updated text');

      final state = cubit.state as GetRoomMessagesSuccess;
      expect(state.messages.first.text, 'Updated text');
    });

    test('editMessage fails on empty text or error', () async {
      repo.messages = [
        _message('m1', 'Original', roomId: 'r1', senderId: 'u1'),
      ];
      await cubit.initializeChat(roomId: 'r1');

      final emptyError = await cubit.editMessage(messageId: 'm1', text: '   ');
      expect(emptyError, isNotNull);

      repo.failEdit = true;
      final serverError = await cubit.editMessage(
        messageId: 'm1',
        text: 'New text',
      );
      expect(serverError, 'Failed to edit');
    });

    test('deleteSingleMessage marks message as deleted', () async {
      repo.messages = [
        _message('m1', 'To be deleted', roomId: 'r1', senderId: 'u1'),
      ];
      await cubit.initializeChat(roomId: 'r1');

      final error = await cubit.deleteSingleMessage(messageId: 'm1');
      expect(error, isNull);
      expect(repo.lastDeletedId, 'm1');

      final state = cubit.state as GetRoomMessagesSuccess;
      expect(state.messages.first.deletedForEveryone, isTrue);
    });

    test('remote socket messageEdited updates message in realtime', () async {
      repo.messages = [
        _message('m1', 'Old text', roomId: 'r1', senderId: 'u1'),
      ];
      await cubit.initializeChat(roomId: 'r1');

      socket.emitMessageEdited(
        _message('m1', 'Remotely edited', roomId: 'r1', senderId: 'u1'),
      );

      final state = cubit.state as GetRoomMessagesSuccess;
      expect(state.messages.first.text, 'Remotely edited');
    });

    test('remote socket messageDeleted marks message in realtime', () async {
      repo.messages = [
        _message('m1', 'Live message', roomId: 'r1', senderId: 'u1'),
      ];
      await cubit.initializeChat(roomId: 'r1');

      socket.emitMessageDeleted('m1');

      final state = cubit.state as GetRoomMessagesSuccess;
      expect(state.messages.first.deletedForEveryone, isTrue);
    });
  });
}

ChatMessageModel _message(
  String id,
  String text, {
  String roomId = 'room-1',
  String senderId = 'sender-1',
  String senderRole = 'student',
  bool deletedForEveryone = false,
  String messageType = 'text',
  DateTime? createdAt,
}) => ChatMessageModel(
  id: id,
  roomId: roomId,
  sender: ChatSenderModel(
    id: senderId,
    fullName: 'Test User',
    role: senderRole,
  ),
  text: text,
  attachments: const [],
  messageType: messageType,
  deletedForEveryone: deletedForEveryone,
  createdAt: createdAt ?? DateTime.now(),
);

class _FakeChatRepo implements ChatRepo {
  List<ChatMessageModel> messages = [];
  String? lastEditedId;
  String? lastEditedText;
  String? lastDeletedId;
  bool failEdit = false;
  bool failDelete = false;

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
  Future<Either<Failure, ChatMessageResponseModel>> editMessage({
    required String messageId,
    required String text,
  }) async {
    if (failEdit) return Left(Failure(message: 'Failed to edit'));
    lastEditedId = messageId;
    lastEditedText = text;
    final index = messages.indexWhere((m) => m.id == messageId);
    final old = index != -1 ? messages[index] : null;
    final updated = ChatMessageModel(
      id: messageId,
      roomId: old?.roomId ?? 'room-1',
      sender: old?.sender ?? const ChatSenderModel(id: 'u1', fullName: 'U', role: 'student'),
      text: text,
      attachments: old?.attachments ?? const [],
      messageType: old?.messageType ?? 'text',
      deletedForEveryone: false,
      createdAt: old?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      editedAt: DateTime.now(),
    );
    return Right(ChatMessageResponseModel(success: true, message: updated));
  }

  @override
  Future<Either<Failure, void>> deleteMessage({required String messageId}) async {
    if (failDelete) return Left(Failure(message: 'Failed to delete'));
    lastDeletedId = messageId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteMessages({
    required String roomId,
    required List<String> messageIds,
  }) async {
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSocketService implements SocketService {
  void Function(ChatMessageModel)? onMessageEdited;
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
  VoidCallback listenToNewMessage(void Function(ChatMessageModel) listener) => () {};

  @override
  VoidCallback listenToMessageEdited(void Function(ChatMessageModel) listener) {
    onMessageEdited = listener;
    return () {};
  }

  @override
  VoidCallback listenToMessageDeleted(void Function(String) listener) {
    onMessageDeleted = listener;
    return () {};
  }

  @override
  VoidCallback listenToReconnect(VoidCallback listener) => () {};

  void emitMessageEdited(ChatMessageModel message) => onMessageEdited?.call(message);
  void emitMessageDeleted(String id) => onMessageDeleted?.call(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
