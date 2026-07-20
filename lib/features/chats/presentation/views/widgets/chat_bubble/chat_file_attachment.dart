import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_formatters.dart';
import 'package:flutter/material.dart';

class ChatFileAttachment extends StatelessWidget {
  const ChatFileAttachment({
    super.key,
    required this.attachment,
    required this.isMe,
    required this.icon,
    required this.title,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: isMe
            ? ColorManager.white.withAlpha(25)
            : ColorManager.mainColor14.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMe
              ? ColorManager.white.withAlpha(50)
              : ColorManager.mainColor14.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 10),
          Expanded(child: _buildDetails(context)),
          const SizedBox(width: 8),
          Icon(
            Icons.download_outlined,
            color: isMe ? ColorManager.white : ColorManager.mainColor14,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return CircleAvatar(
      backgroundColor: isMe
          ? ColorManager.white.withAlpha(35)
          : ColorManager.mainColor14.withAlpha(20),
      child: Icon(
        icon,
        color: isMe ? ColorManager.white : ColorManager.mainColor14,
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleRegular14(context).copyWith(
            color: isMe ? ColorManager.white : ColorManager.black,
          ),
        ),
        if (attachment.size > 0)
          Text(
            ChatFormatters.formatFileSize(attachment.size),
            style: StylesManager.styleRegular14(context).copyWith(
              fontSize: 11,
              color: isMe ? ColorManager.grey9D9D : ColorManager.grey7A7C,
            ),
          ),
      ],
    );
  }
}