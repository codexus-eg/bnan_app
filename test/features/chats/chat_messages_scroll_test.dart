import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('history load opens at the latest message', (tester) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key, isLoading: true);

    key.currentState!.loadHistory(_messages(30).reversed.toList());
    await tester.pumpAndSettle();

    _expectAtBottom(tester);
    expect(find.text('message-29'), findsOneWidget);
  });

  testWidgets('incoming message scrolls when user is near bottom', (
    tester,
  ) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key, messages: _messages(30));

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 50));
    key.currentState!.append(_message(30, senderId: 'other'));
    await tester.pumpAndSettle();

    _expectAtBottom(tester);
  });

  testWidgets('incoming message does not pull user from old history', (
    tester,
  ) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key, messages: _messages(30));
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    final before = _position(tester).pixels;

    key.currentState!.append(_message(30, senderId: 'other'));
    await tester.pumpAndSettle();

    expect(_position(tester).pixels, closeTo(before, 0.1));
    expect(
      _position(tester).pixels,
      lessThan(_position(tester).maxScrollExtent),
    );
  });

  testWidgets('POST-confirmed sender message follows near-bottom rule', (
    tester,
  ) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key, messages: _messages(30));

    key.currentState!.append(_message(30, senderId: 'me'));
    await tester.pumpAndSettle();

    _expectAtBottom(tester);
  });

  testWidgets('empty history and first message do not crash', (tester) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key);

    key.currentState!.append(_message(0, senderId: 'other'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('message-0'), findsOneWidget);
  });

  testWidgets('rebuild without a new message preserves scroll offset', (
    tester,
  ) async {
    final key = GlobalKey<_ChatHarnessState>();
    await _pumpHarness(tester, key: key, messages: _messages(30));
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 350));
    await tester.pumpAndSettle();
    final before = _position(tester).pixels;

    key.currentState!.rebuildOnly();
    await tester.pumpAndSettle();

    expect(_position(tester).pixels, closeTo(before, 0.1));
  });
}

Future<void> _pumpHarness(
  WidgetTester tester, {
  required GlobalKey<_ChatHarnessState> key,
  List<ChatMessageModel> messages = const [],
  bool isLoading = false,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 500));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: _ChatHarness(
          key: key,
          initialMessages: messages,
          initiallyLoading: isLoading,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

ScrollPosition _position(WidgetTester tester) {
  return tester.state<ScrollableState>(find.byType(Scrollable)).position;
}

void _expectAtBottom(WidgetTester tester) {
  final position = _position(tester);
  expect(position.pixels, closeTo(position.maxScrollExtent, 0.1));
}

List<ChatMessageModel> _messages(int count) {
  return List.generate(count, _message);
}

ChatMessageModel _message(int index, {String senderId = 'other'}) {
  return ChatMessageModel(
    id: 'message-$index',
    roomId: 'room-1',
    sender: ChatSenderModel(id: senderId, fullName: 'Sender', role: 'student'),
    text: 'message-$index',
    attachments: const [],
    messageType: 'text',
    deletedForEveryone: false,
    createdAt: DateTime.utc(2026).add(Duration(minutes: index)),
  );
}

class _ChatHarness extends StatefulWidget {
  const _ChatHarness({
    super.key,
    required this.initialMessages,
    required this.initiallyLoading,
  });

  final List<ChatMessageModel> initialMessages;
  final bool initiallyLoading;

  @override
  State<_ChatHarness> createState() => _ChatHarnessState();
}

class _ChatHarnessState extends State<_ChatHarness> {
  late List<ChatMessageModel> messages = widget.initialMessages;
  late bool isLoading = widget.initiallyLoading;

  void loadHistory(List<ChatMessageModel> value) {
    setState(() {
      messages = value;
      isLoading = false;
    });
  }

  void append(ChatMessageModel message) {
    setState(() => messages = [...messages, message]);
  }

  void rebuildOnly() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ChatMessagesList(
      messages: messages,
      currentUserId: 'me',
      isLoading: isLoading,
    );
  }
}
