import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_download_icon.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/custom_shared_home_info.dart';
import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({
    super.key,
    required this.certificate,
    required this.onDownloadTap,
  });

  final CertificateModel certificate;
  final VoidCallback onDownloadTap;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          CustomIconBox(imagePath: certificate.icon),
          const SizedBox(width: 8),
          CustomSharedHomeInfo(title: certificate.title, subtitle: certificate.subtitle),
          const Spacer(),
          CertificateDownloadIcon(onTap: onDownloadTap),
        ],
      ),
    );
  }
}
