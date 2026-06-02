import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/schedule/data/models/chat_message_model.dart';
import 'package:bnan_app/features/schedule/data/models/chat_sender_type.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessageModel message;

  bool get isMe => message.senderType == ChatSenderType.me;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isMe ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .65,
        ),
        padding: const EdgeInsetsDirectional.all(8),
        decoration: BoxDecoration(
          color: isMe ? ColorManager.mainColor14 : ColorManager.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withAlpha((255 * .25).round()),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: StylesManager.styleRegular14(context).copyWith(
                color: isMe ? ColorManager.white : ColorManager.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.time,
              style: StylesManager.styleRegular14(context).copyWith(
                color: isMe ? ColorManager.grey9D9D : ColorManager.grey7A7C,
              ),
            ),
          ],
        ),
      ),
    );
  }
}