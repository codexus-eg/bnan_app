import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/message_document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('document selection returns to and highlights source message B', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _Harness()));
    await tester.tap(find.text('All Documents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('document.pdf'));
    await tester.pumpAndSettle();

    final bubbles = tester.widgetList<ChatBubble>(find.byType(ChatBubble));
    expect(
      bubbles
          .singleWhere((bubble) => bubble.message.id == 'message-b')
          .highlighted,
      isTrue,
    );
  });
}

class _Harness extends StatefulWidget {
  const _Harness();
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  final messagesKey = GlobalKey<ChatMessagesListState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        TextButton(
          onPressed: _openDocuments,
          child: const Text('All Documents'),
        ),
        Expanded(
          child: ChatMessagesList(
            key: messagesKey,
            messages: const [_messageA, _messageB, _messageC],
            currentUserId: 'current',
          ),
        ),
      ],
    ),
  );

  Future<void> _openDocuments() async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: MessageDocumentCard(
            item: const MessageDocumentItem(
              id: 'message-b:attachment',
              messageId: 'message-b',
              url: 'https://example.com/document.pdf',
              fileName: 'document.pdf',
              messageTitle: '',
              senderName: 'Teacher',
              mimeType: 'application/pdf',
              size: 10,
              createdAt: null,
              isExternalLink: false,
            ),
            onTap: () => Navigator.of(context).pop('message-b'),
          ),
        ),
      ),
    );
    if (id != null) await messagesKey.currentState?.scrollToMessage(id);
  }
}

const _sender = ChatSenderModel(
  id: 'sender',
  fullName: 'Teacher',
  role: 'teacher',
);
const _messageA = ChatMessageModel(
  id: 'message-a',
  roomId: 'room',
  sender: _sender,
  text: 'A',
  attachments: [],
  messageType: 'text',
  deletedForEveryone: false,
);
const _messageB = ChatMessageModel(
  id: 'message-b',
  roomId: 'room',
  sender: _sender,
  text: 'B',
  attachments: [],
  messageType: 'text',
  deletedForEveryone: false,
);
const _messageC = ChatMessageModel(
  id: 'message-c',
  roomId: 'room',
  sender: _sender,
  text: 'C',
  attachments: [],
  messageType: 'text',
  deletedForEveryone: false,
);
