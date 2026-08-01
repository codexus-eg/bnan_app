import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_placeholder.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class AttachmentImage extends StatelessWidget {
  const AttachmentImage({
    super.key,
    required this.url,
    required this.fit,
    required this.errorMessage,
  });

  final String url;
  final BoxFit fit;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: fit,
      );
    }
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : AppSkeletonizer(
              isLoading: true,
              child: ColoredBox(color: ColorManager.greyF4F6),
            ),
      errorBuilder: (_, _, _) => AttachmentPlaceholder(message: errorMessage),
    );
  }
}
