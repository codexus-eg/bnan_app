import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
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
   

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        attachment.fileUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: _buildLoading,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('IMAGE LOAD ERROR: $error');
          debugPrint('IMAGE URL: ${attachment.fileUrl}');

          return _buildError(context);
        },
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) {
    if (progress == null) {
      return child;
    }

    return Container(
      height: 180,
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
        'تعذر تحميل الصورة',
        style: StylesManager.styleRegular14(context).copyWith(
          color: isMe ? ColorManager.white : ColorManager.black,
        ),
      ),
    );
  }
}