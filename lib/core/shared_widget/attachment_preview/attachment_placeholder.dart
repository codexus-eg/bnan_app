import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AttachmentPlaceholder extends StatelessWidget {
  const AttachmentPlaceholder({
    super.key,
    required this.message,
    this.isPdf = false,
  });

  final String message;
  final bool isPdf;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorManager.greyF4F6,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.broken_image_outlined,
              color: ColorManager.greyA8AF,
              size: 34,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
          ],
        ),
      ),
    );
  }
}
