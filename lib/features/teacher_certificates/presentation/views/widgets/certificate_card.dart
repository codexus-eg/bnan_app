import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_certificates/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_actions.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_image.dart';
import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.certificate});

  final TeacherCertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CertificateImage(imageUrl: certificate.imageUrl),
          CertificateActions(certificate: certificate),
        ],
      ),
    );
  }
}
