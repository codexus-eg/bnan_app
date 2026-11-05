import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_edit_message_dialog.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_message_actions_sheet.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepo implements ChatRepo {
  String? lastEditedText;

  @override
  Future<Either<Failure, ChatMessageResponseModel>> editMessage({
    required String messageId,
    required String text,
  }) async {
    lastEditedText = text;
    final updated = ChatMessageModel(
      id: messageId,
      roomId: 'room1',
      sender: const ChatSenderModel(id: 'u1', fullName: 'User', role: 'student'),
      text: text,
      attachments: const [],
      messageType: 'text',
      deletedForEveryone: false,
      createdAt: DateTime.now(),
    );
    return Right(ChatMessageResponseModel(success: true, message: updated));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSocketService implements SocketService {
  @override
  VoidCallback listenToMessageEdited(void Function(ChatMessageModel) listener) => () {};
  @override
  VoidCallback listenToMessageDeleted(void Function(String) listener) => () {};
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ChatMessageModel _buildMessage(String id, String text) => ChatMessageModel(
  id: id,
  roomId: 'room1',
  sender: const ChatSenderModel(id: 'u1', fullName: 'User', role: 'student'),
  text: text,
  attachments: const [],
  messageType: 'text',
  deletedForEveryone: false,
  createdAt: DateTime.now(),
);

Widget _wrapWithApp({required Widget child, required GetRoomMessagesCubit cubit}) {
  return MaterialApp(
    locale: const Locale('ar'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider<GetRoomMessagesCubit>.value(
      value: cubit,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  testWidgets('showChatMessageActionsSheet returns selected action', (tester) async {
    ChatMessageMenuAction? selected;
    final message = _buildMessage('m1', 'Hello');

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                selected = await showChatMessageActionsSheet(
                  context,
                  message: message,
                  canEdit: true,
                  canDelete: true,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text(S.current.edit), findsOneWidget);
    expect(find.text(S.current.delete), findsOneWidget);

    await tester.tap(find.text(S.current.edit));
    await tester.pumpAndSettle();

    expect(selected, ChatMessageMenuAction.edit);
  });

  testWidgets('showEditChatMessageDialog validates and submits new text', (tester) async {
    final fakeRepo = _FakeChatRepo();
    final fakeSocket = _FakeSocketService();
    final cubit = GetRoomMessagesCubit(fakeRepo, fakeSocket);
    final message = _buildMessage('m1', 'Original message');

    await tester.pumpWidget(
      _wrapWithApp(
        cubit: cubit,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showEditChatMessageDialog(context, message),
            child: const Text('Edit'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Original message'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Updated message content');
    await tester.tap(find.text(S.current.save));
    await tester.pumpAndSettle();

    expect(fakeRepo.lastEditedText, 'Updated message content');
  });
}
