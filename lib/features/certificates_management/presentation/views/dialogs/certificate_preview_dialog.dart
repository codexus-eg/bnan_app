import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_preview_actions.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/preview_image.dart';
import 'package:flutter/material.dart';

class CertificatePreviewDialog extends StatelessWidget {
  const CertificatePreviewDialog({
    super.key,
    required this.imageUrl,
    required this.pdfUrl,
  });

  final String imageUrl, pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreviewImage(imageUrl: imageUrl),
          const SizedBox(height: 16),
          CertificatePreviewActions(pdfUrl: pdfUrl),
        ],
      ),
    );
  }
}
