import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_audio_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_file_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_attachment.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_video_attachment.dart';
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
      return ChatImageAttachment(attachment: attachment, isMe: isMe);
    }

    if (attachment.isAudio) {
      return ChatAudioAttachment(attachment: attachment, isMe: isMe);
    }

    if (attachment.isVideo) {
      return ChatVideoAttachment(attachment: attachment, isMe: isMe);
    }

    return ChatFileAttachment(
      attachment: attachment,
      isMe: isMe,
      icon: attachment.isPdf
          ? Icons.picture_as_pdf_outlined
          : Icons.insert_drive_file_outlined,
      title: attachment.fileName,
    );
  }
}
