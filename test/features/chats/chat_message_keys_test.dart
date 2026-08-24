import 'dart:async';

import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('message targeting keys remain unique through updates', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await _pump(tester, harnessKey, _messages(10));
    expect(tester.takeException(), isNull);

    harnessKey.currentState!.rebuildOnly();
    await tester.pump();
    harnessKey.currentState!.append(_message('message-10'));
    await tester.pump();

    expect(find.byType(ChatBubble), findsNWidgets(11));
    expect(tester.takeException(), isNull);
  });

  testWidgets('duplicate ids render once and missing ids render unkeyed', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await _pump(tester, harnessKey, [
      _message('same'),
      _message('same'),
      _message(''),
      _message(''),
    ]);

    expect(find.byType(ChatBubble), findsNWidgets(3));
    final emptyBubbles = tester
        .widgetList<ChatBubble>(find.byType(ChatBubble))
        .where((bubble) => bubble.message.id.isEmpty);
    expect(emptyBubbles, hasLength(2));
    expect(emptyBubbles.every((bubble) => bubble.key == null), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('jump succeeds and a missing target returns safely', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_HarnessState>();
    await _pump(tester, harnessKey, _messages(20));

    final jump = harnessKey.currentState!.jump('message-0');
    await _pumpUntilComplete(tester, jump);
    expect(_bubble(tester, 'message-0').highlighted, isTrue);

    await harnessKey.currentState!.jump('missing');
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

Future<void> _pumpUntilComplete(
  WidgetTester tester,
  Future<void> future,
) async {
  var completed = false;
  unawaited(future.whenComplete(() => completed = true));
  for (var frame = 0; frame < 10 && !completed; frame++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(completed, isTrue);
  await future;
}

Future<void> _pump(
  WidgetTester tester,
  GlobalKey<_HarnessState> key,
  List<ChatMessageModel> messages,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: _Harness(key: key, data: messages),
    ),
  );
  await tester.pumpAndSettle();
}

ChatBubble _bubble(WidgetTester tester, String id) => tester
    .widgetList<ChatBubble>(find.byType(ChatBubble))
    .singleWhere((bubble) => bubble.message.id == id);

List<ChatMessageModel> _messages(int count) =>
    List.generate(count, (index) => _message('message-$index'));

ChatMessageModel _message(String id) => ChatMessageModel(
  id: id,
  roomId: 'room-1',
  sender: const ChatSenderModel(
    id: 'sender',
    fullName: 'Sender',
    role: 'student',
  ),
  text: id,
  attachments: const [],
  messageType: 'text',
  deletedForEveryone: false,
);

class _Harness extends StatefulWidget {
  const _Harness({super.key, required this.data});
  final List<ChatMessageModel> data;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late List<ChatMessageModel> messages = widget.data;
  final listKey = GlobalKey<ChatMessagesListState>();

  void rebuildOnly() => setState(() {});
  void append(ChatMessageModel message) =>
      setState(() => messages = [...messages, message]);
  Future<void> jump(String id) => listKey.currentState!.scrollToMessage(id);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChatMessagesList(
      key: listKey,
      messages: messages,
      currentUserId: 'current',
    ),
  );
}
