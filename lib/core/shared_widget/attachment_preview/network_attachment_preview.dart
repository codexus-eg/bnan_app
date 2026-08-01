import 'package:bnan_app/core/helper/attachment_url_resolver.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_full_screen_preview.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_preview_content.dart';
import 'package:flutter/material.dart';

class NetworkAttachmentPreview extends StatelessWidget {
  const NetworkAttachmentPreview({
    super.key,
    required this.attachmentUrl,
    this.width,
    this.height = 193,
    this.borderRadius,
    this.fit = BoxFit.contain,
    this.title,
    this.enablePreview = true,
  });

  final String attachmentUrl;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final String? title;
  final bool enablePreview;

  @override
  Widget build(BuildContext context) {
    final url = AttachmentUrlResolver.resolve(attachmentUrl);
    final isPdf = AttachmentUrlResolver.isPdf(url);
    final canOpen =
        enablePreview && url.isNotEmpty && !isPdf && !url.startsWith('assets/');
    final child = AttachmentPreviewContent(url: url, isPdf: isPdf, fit: fit);
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        
        child: InkWell(
          onTap: canOpen ? () => _open(context, url) : null,
          child: child,
        ),
      ),
    );
  }

  void _open(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AttachmentFullScreenPreview(url: url, title: title),
      ),
    );
  }
}
