import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/certificates/certificate_download_icon.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/certificates/certificate_icon_box.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/certificates/certificate_info.dart';
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
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CertificateIconBox(icon: certificate.icon),
          const SizedBox(width: 8),
          CertificateInfo(certificate: certificate),
          const Spacer(),
          CertificateDownloadIcon(onTap: onDownloadTap),
        ],
      ),
    );
  }
}
