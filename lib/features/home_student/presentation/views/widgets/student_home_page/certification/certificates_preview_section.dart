import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/shared_widgets/material_header.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/certificates/certificate_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificatesPreviewSection extends StatelessWidget {
  const CertificatesPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final certificate = CertificateModel(
      title: S.of(context).mayCertificate,
      subtitle: S.of(context).averagePercent('92'),
      icon: ImageManager.certificateBadgeIcon,
    );

    return Column(
      
      children: [
       MaterialsHeader(onViewAllTap: (){}, header: S.of(context).certificates),
        const SizedBox(height: 8),
        CertificateCard(
          certificate: certificate,
          onDownloadTap: () {},
        ),
      ],
    );
  }
}