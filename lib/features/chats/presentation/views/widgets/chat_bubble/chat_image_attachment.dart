import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_image_preview.dart';
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
    return GestureDetector(
      onTap: () => _openPreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          attachment.fileUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: _buildLoading,
          errorBuilder: (_, error, __) {
            debugPrint('IMAGE LOAD ERROR: $error');
            debugPrint('IMAGE URL: ${attachment.fileUrl}');

            return _buildError(context);
          },
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatImagePreview(
          imageUrl: attachment.fileUrl,
        ),
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) {
    if (progress == null) return child;

    return Container(
      height: 200,
      alignment: Alignment.center,
      color: ColorManager.grey9D9D.withAlpha(30),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: isMe
            ? ColorManager.white
            : ColorManager.mainColor14,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      color: ColorManager.grey9D9D.withAlpha(30),
      child: Text(
        'تعذر تحميل الصورة',
        style: StylesManager.styleRegular14(context).copyWith(
          color: isMe
              ? ColorManager.white
              : ColorManager.black,
        ),
      ),
    );
  }
}