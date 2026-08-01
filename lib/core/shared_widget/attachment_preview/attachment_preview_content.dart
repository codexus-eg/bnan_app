import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_image.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_placeholder.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AttachmentPreviewContent extends StatelessWidget {
  const AttachmentPreviewContent({
    super.key,
    required this.url,
    required this.isPdf,
    required this.fit,
  });

  final String url;
  final bool isPdf;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || isPdf) {
      return AttachmentPlaceholder(
        message: isPdf
            ? S.of(context).unableToOpenAttachment
            : S.of(context).unableToLoadAttachment,
        isPdf: isPdf,
      );
    }
    return AttachmentImage(
      url: url,
      fit: fit,
      errorMessage: S.of(context).unableToLoadAttachment,
    );
  }
}
