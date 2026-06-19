import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_header_card.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificatesBody extends StatelessWidget {
  const CertificatesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final certificates = [
      CertificateModel(
        title: S.of(context).mayCertificate,
        subtitle: S.of(context).averagePercent('92'),
        icon: ImageManager.certificateBadgeIcon,
      ),
      CertificateModel(
        title: S.of(context).algebraCourseCertificate,
        subtitle: S.of(context).april2026,
        icon: ImageManager.certificateBadgeIcon,
      ),
      CertificateModel(
        title: S.of(context).interactionAppreciationCertificate,
        subtitle: S.of(context).march2026,
        icon: ImageManager.certificateBadgeIcon,
      ),
    ];

    return Column(
      children: [
        CustomAppbar(headerText: S.of(context).certificates ,iconNeeded: false),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                const CertificatesHeaderCard(),
                const SizedBox(height: 16),
                CertificatesList(certificates: certificates),
              ],
            ),
          ),
        ),
      ],
    );
  }
}