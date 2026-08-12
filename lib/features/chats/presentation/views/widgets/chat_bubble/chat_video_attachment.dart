import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_attachment_url.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_video_player_view.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/generated/l10n.dart';

class ChatVideoAttachment extends StatelessWidget {
  const ChatVideoAttachment({
    super.key,
    required this.attachment,
    required this.isMe,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _openVideo(context),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorManager.black.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CircleAvatar(
            radius: 28,
            backgroundColor: ColorManager.black.withAlpha(120),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context) {
    final uri = ChatAttachmentUrl.resolve(attachment.fileUrl);
    if (uri == null) {
      showCustomSnackBar(context, S.of(context).invalidLink, false);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatVideoPlayerView(
          videoUrl: uri.toString(),
          headers: ChatAttachmentUrl.headersFor(uri),
        ),
      ),
    );
  }
}
