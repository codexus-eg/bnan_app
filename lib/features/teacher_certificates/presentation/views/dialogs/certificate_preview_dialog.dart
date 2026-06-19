import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_preview_actions.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/preview_image.dart';
import 'package:flutter/material.dart';

class CertificatePreviewDialog extends StatelessWidget {
  const CertificatePreviewDialog({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:  EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreviewImage(imageUrl: imageUrl),
          const SizedBox(height: 16),
          const CertificatePreviewActions(),
        ],
      ),
    );
  }
}

