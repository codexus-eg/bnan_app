import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_attachment_url.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_preview.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatImageAttachment extends StatelessWidget {
  const ChatImageAttachment({
    super.key,
    required this.attachment,
    required this.isMe,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final uri = ChatAttachmentUrl.resolve(attachment.fileUrl);
    return GestureDetector(
      key: const Key('chatImageAttachment'),
      onTap: () =>
          uri == null ? _showInvalidUrl(context) : _openPreview(context, uri),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: uri == null
            ? _buildError(context)
            : Image.network(
                uri.toString(),
                headers: ChatAttachmentUrl.headersFor(uri),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: _buildLoading,
                errorBuilder: (_, __, ___) => _buildError(context),
              ),
      ),
    );
  }

  void _openPreview(BuildContext context, Uri uri) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatImagePreview(
          imageUrl: uri.toString(),
          headers: ChatAttachmentUrl.headersFor(uri),
        ),
      ),
    );
  }

  void _showInvalidUrl(BuildContext context) {
    showCustomSnackBar(context, S.of(context).invalidLink, false);
  }

  Widget _buildLoading(BuildContext context, Widget child, ImageChunkEvent? p) {
    if (p == null) return child;
    return Container(
      height: 200,
      alignment: Alignment.center,
      color: ColorManager.grey9D9D.withAlpha(30),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: isMe ? ColorManager.white : ColorManager.mainColor14,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      color: ColorManager.grey9D9D.withAlpha(30),
      child: Text(
        S.of(context).unableToLoadAttachment,
        style: StylesManager.styleRegular14(
          context,
        ).copyWith(color: isMe ? ColorManager.white : ColorManager.black),
      ),
    );
  }
}
