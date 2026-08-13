import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_attachments_list.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_formatters.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.highlighted = false,
  });

  final ChatMessageModel message;
  final String currentUserId;
  final bool highlighted;

  bool get isMe => message.sender.id == currentUserId;

  @override
  Widget build(BuildContext context) {
    final hasText = message.text.trim().isNotEmpty;

    return Align(
      alignment: isMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .70,
        ),
        padding: const EdgeInsetsDirectional.all(8),
        decoration: _buildDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.attachments.isNotEmpty)
              ChatAttachmentsList(attachments: message.attachments, isMe: isMe),
            if (message.attachments.isNotEmpty && hasText)
              const SizedBox(height: 8),
            if (hasText) _buildMessageText(context),
            const SizedBox(height: 8),
            _buildTime(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: isMe ? ColorManager.mainColor14 : ColorManager.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: ColorManager.black.withAlpha(64),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
      border: highlighted
          ? Border.all(color: ColorManager.orangeE6, width: 2)
          : null,
    );
  }

  Widget _buildMessageText(BuildContext context) {
    return Text(
      message.text,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: StylesManager.styleRegular14(
        context,
      ).copyWith(color: isMe ? ColorManager.white : ColorManager.black),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Text(
      ChatFormatters.formatTime(message.createdAt),
      style: StylesManager.styleRegular14(context).copyWith(
        fontSize: 11,
        color: isMe ? ColorManager.grey9D9D : ColorManager.grey7A7C,
      ),
    );
  }
}
