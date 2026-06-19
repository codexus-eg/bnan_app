import 'package:bnan_app/features/student_schedule/data/models/chat_message_model.dart';
import 'package:bnan_app/features/student_schedule/data/models/chat_sender_type.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/widgets/chat_widgets/chat_header.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/widgets/chat_widgets/chat_input_bar.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/widgets/chat_widgets/chat_messages_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      ChatMessageModel(
        message: S.of(context).chatMsg1,
        time: '5:10م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg2,
        time: '5:12م',
        senderType: ChatSenderType.me,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg3,
        time: '5:13م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg4,
        time: '5:14م',
        senderType: ChatSenderType.me,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg1,
        time: '5:10م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg2,
        time: '5:12م',
        senderType: ChatSenderType.me,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg3,
        time: '5:13م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg4,
        time: '5:14م',
        senderType: ChatSenderType.me,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg1,
        time: '5:10م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg2,
        time: '5:12م',
        senderType: ChatSenderType.me,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg3,
        time: '5:13م',
        senderType: ChatSenderType.other,
      ),
      ChatMessageModel(
        message: S.of(context).chatMsg4,
        time: '5:14م',
        senderType: ChatSenderType.me,
      ),
    ];

    return Column(
      children: [
        const ChatHeader(),
        Expanded(child: ChatMessagesList(messages: messages)),
        const ChatInputBar(),
      ],
    );
  }
}
