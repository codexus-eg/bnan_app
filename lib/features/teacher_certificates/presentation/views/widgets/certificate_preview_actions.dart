import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_preview_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificatePreviewActions extends StatelessWidget {
  const CertificatePreviewActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CertificatePreviewButton(
          title: S.of(context).downloadPdf,
          imageUrl: ImageManager.downloadIcon,
          isPrimary: true,
          onTap: () {},
        ),
        const SizedBox(width: 20),
        CertificatePreviewButton(
          title: S.of(context).close,
          icon: Icons.close,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}