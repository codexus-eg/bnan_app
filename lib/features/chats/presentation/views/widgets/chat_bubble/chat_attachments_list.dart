import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_attachment_item.dart';
import 'package:flutter/material.dart';

class ChatAttachmentsList extends StatelessWidget {
  const ChatAttachmentsList({
    super.key,
    required this.attachments,
    required this.isMe,
  });

  final List<ChatAttachmentModel> attachments;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (attachments.length == 1) {
      return ChatAttachmentItem(attachment: attachments.first, isMe: isMe);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(attachments.length, (index) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: index == attachments.length - 1 ? 0 : 8,
          ),
          child: ChatAttachmentItem(attachment: attachments[index], isMe: isMe),
        );
      }),
    );
  }
}
