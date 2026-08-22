import 'package:bnan_app/core/shared_widget/custom_chat_card.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [320.0, 360.0]) {
    testWidgets('chat card and full bubble text fit at $width RTL', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const long =
          'هذا نص طويل جدًا لاختبار عدم خروج محتوى الرسالة '
          'أو اسم المحادثة عن حدود الكارت على الشاشات الصغيرة';
      const unbroken =
          'https://example.com/verylongpathwithoutanybreakpoints1234567890.pdf';
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  CustomChatCard(title: '$long $long', subtitle: unbroken),
                  ChatBubble(
                    message: ChatMessageModel(
                      id: 'message',
                      roomId: 'room',
                      sender: ChatSenderModel(
                        id: 'sender',
                        fullName: 'Sender',
                        role: 'teacher',
                      ),
                      text: '$long $unbroken',
                      attachments: [],
                      messageType: 'text',
                      deletedForEveryone: false,
                    ),
                    currentUserId: 'other',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Sender (Teacher)'), findsOneWidget);
      expect(find.text('$long $unbroken'), findsOneWidget);
    });
  }

  testWidgets('current user name is hidden above own message', (tester) async {
    const message = ChatMessageModel(
      id: 'message',
      roomId: 'room',
      sender: ChatSenderModel(id: 'me', fullName: 'My Name', role: 'teacher'),
      text: 'Hello',
      attachments: [],
      messageType: 'text',
      deletedForEveryone: false,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChatBubble(message: message, currentUserId: 'me'),
        ),
      ),
    );

    expect(find.text('My Name'), findsNothing);
    expect(find.text('Hello'), findsOneWidget);
  });
}
