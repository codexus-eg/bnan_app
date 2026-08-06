import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/mappers/message_document_mapper.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'filters text-only and invalid attachments, keeps supported documents',
    () {
      final messages = [
        _message(text: 'ordinary message'),
        _message(
          attachment: _attachment(
            'report.pdf',
            'https://x.test/a.pdf',
            'application/pdf',
          ),
        ),
        _message(
          attachment: _attachment('', 'https://x.test/image', 'image/png'),
        ),
        _message(attachment: _attachment('missing.pdf', '', 'application/pdf')),
        _message(text: 'https://zoom.us/rec/share/example'),
      ];
      final items = MessageDocumentMapper.fromMessages(messages);
      expect(items, hasLength(3));
      expect(
        items.map((item) => item.url),
        containsAll([
          'https://x.test/a.pdf',
          'https://x.test/image',
          'https://zoom.us/rec/share/example',
        ]),
      );
    },
  );

  test('nullable sender, name and date parsing never crashes', () {
    final message = ChatMessageModel.fromJson({
      'id': 'm',
      'sender': null,
      'createdAt': null,
      'attachments': [
        {'fileName': null, 'fileUrl': 'https://x.test/file', 'mimeType': null},
      ],
    });
    final item = MessageDocumentMapper.fromMessages([message]).single;
    expect(item.fileName, isEmpty);
    expect(item.senderName, isEmpty);
    expect(item.createdAt, isNull);
  });

  test(
    'cubit uses roomId, caches success, refreshes and retries failure',
    () async {
      final repo = _ChatRepo();
      final cubit = MessageDocumentsCubit(repo);
      final states = <ClassroomDocumentsState<MessageDocumentItem>>[];
      final subscription = cubit.stream.listen(states.add);
      await cubit.load('room-id');
      expect(repo.roomIds, ['room-id']);
      expect(states.first, isA<DocumentsLoading>());
      expect(cubit.state, isA<DocumentsSuccess>());
      await cubit.load('room-id');
      expect(repo.roomIds, hasLength(1));
      await cubit.load('room-id', refresh: true);
      expect(repo.roomIds, hasLength(2));
      repo.failure = true;
      await cubit.load('room-id', refresh: true);
      expect(cubit.state, isA<DocumentsFailure>());
      repo.failure = false;
      await cubit.load('room-id', refresh: true);
      expect(cubit.state, isA<DocumentsSuccess>());
      await subscription.cancel();
      await cubit.close();
    },
  );

  test('cubit emits empty when messages contain no documents', () async {
    final repo = _ChatRepo()..messages = [_message(text: 'ordinary')];
    final cubit = MessageDocumentsCubit(repo);
    await cubit.load('room-id');
    expect(cubit.state, isA<DocumentsEmpty>());
    await cubit.close();
  });
}

ChatMessageModel _message({String text = '', ChatAttachmentModel? attachment}) {
  return ChatMessageModel(
    id: 'm-$text-${attachment?.fileName}',
    roomId: 'room-id',
    sender: const ChatSenderModel(
      id: 's',
      fullName: 'Teacher',
      role: 'teacher',
    ),
    text: text,
    attachments: attachment == null ? const [] : [attachment],
    messageType: attachment == null ? 'text' : 'file',
    deletedForEveryone: false,
  );
}

ChatAttachmentModel _attachment(String name, String url, String mime) {
  return ChatAttachmentModel(
    id: name,
    fileName: name,
    fileUrl: url,
    mimeType: mime,
    size: 10,
  );
}

class _ChatRepo implements ChatRepo {
  final roomIds = <String>[];
  bool failure = false;
  List<ChatMessageModel> messages = [
    _message(text: 'https://example.com/document'),
  ];

  @override
  getRoomMessages({required String roomId}) async {
    roomIds.add(roomId);
    if (failure) {
      return Left<Failure, ChatMessagesResponseModel>(
        Failure(message: 'failed'),
      );
    }
    return Right(
      ChatMessagesResponseModel(
        success: true,
        results: messages.length,
        messages: messages,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
