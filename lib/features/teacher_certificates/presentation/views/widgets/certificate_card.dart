import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/teacher_certificates/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_actions.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_image.dart';
import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.certificate});

  final TeacherCertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: CustomDetailsWidgetBackground(
        child: Column(
          children: [
            CertificateImage(imageUrl: certificate.imageUrl),
            CertificateActions(certificate: certificate),
          ],
        ),
      ),
    );
  }
}
