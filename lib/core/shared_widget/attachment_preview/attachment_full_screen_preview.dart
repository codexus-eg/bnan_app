import 'package:bnan_app/core/shared_widget/attachment_preview/attachment_image.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AttachmentFullScreenPreview extends StatelessWidget {
  const AttachmentFullScreenPreview({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: CustomAppbar(headerText: title ?? S.of(context).attachment),
      body: SafeArea(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 5,
          boundaryMargin: const EdgeInsets.all(40),
          child: Center(
            child: AttachmentImage(
              url: url,
              fit: BoxFit.contain,
              errorMessage: S.of(context).unableToLoadAttachment,
            ),
          ),
        ),
      ),
    );
  }
}
