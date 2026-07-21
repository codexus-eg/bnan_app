import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/document_preview_action_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DocumentPreviewActions extends StatelessWidget {
  const DocumentPreviewActions({super.key, required this.pdfUrl});
  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DocumentPreviewActionButton(
          title: S.of(context).close,
          icon: Icons.close,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 20),
        DocumentPreviewActionButton(
          title: S.of(context).downloadPdf,
          imageUrl: ImageManager.downloadIcon,
          isPrimary: true,
          onTap: () async {
            final isOpened = await FileUrlLauncher.open(pdfUrl);

            if (!context.mounted || isOpened) return;
            showCustomSnackBar(context, S.of(context).unableToOpenFile, false);
          },
        ),
      ],
    );
  }
}
