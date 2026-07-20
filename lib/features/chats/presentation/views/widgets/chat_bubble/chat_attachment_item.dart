import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_file_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_attachment.dart';
import 'package:flutter/material.dart';

class ChatAttachmentItem extends StatelessWidget {
  const ChatAttachmentItem({
    super.key,
    required this.attachment,
    required this.isMe,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (attachment.isImage) {
      return ChatImageAttachment(
        attachment: attachment,
        isMe: isMe,
      );
    }

    return ChatFileAttachment(
      attachment: attachment,
      isMe: isMe,
      icon: _getIcon(),
      title: _getTitle(),
    );
  }

  IconData _getIcon() {
    if (attachment.isAudio) {
      return Icons.play_arrow_rounded;
    }

    if (attachment.isVideo) {
      return Icons.videocam_outlined;
    }

    if (attachment.isPdf) {
      return Icons.picture_as_pdf_outlined;
    }

    return Icons.insert_drive_file_outlined;
  }

  String _getTitle() {
    if (attachment.fileName.isNotEmpty) {
      return attachment.fileName;
    }

    if (attachment.isAudio) {
      return 'رسالة صوتية';
    }

    if (attachment.isVideo) {
      return 'فيديو';
    }

    if (attachment.isPdf) {
      return 'ملف PDF';
    }

    return 'ملف مرفق';
  }
}