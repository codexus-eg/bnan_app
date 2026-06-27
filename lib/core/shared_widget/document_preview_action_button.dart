import 'package:bnan_app/core/shared_widget/document_preview_button_icon.dart';
import 'package:bnan_app/core/shared_widget/document_preview_button_label.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DocumentPreviewActionButton extends StatelessWidget {
  const DocumentPreviewActionButton({
    super.key,
    required this.title,
    this.icon,
    this.isPrimary = false,
    this.onTap,
    this.imageUrl,
  });

  final String title;
  final IconData? icon;
  final String? imageUrl;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isPrimary ? ColorManager.white : ColorManager.mainColor14;

    return Expanded(
      child: SizedBox(
        height: 40,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: DocumentPreviewButtonIcon(icon: icon, imageUrl: imageUrl),
          label: DocumentPreviewButtonLabel(title: title, isPrimary: isPrimary),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isPrimary
                ? ColorManager.mainColor14
                : ColorManager.white,
            foregroundColor: textColor,
            textStyle: StylesManager.styleBold12(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
