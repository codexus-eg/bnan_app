import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_card.dart';
import 'package:flutter/material.dart';

class CertificatesList extends StatelessWidget {
  const CertificatesList({super.key, required this.certificates});

  final List<CertificateModel> certificates;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: certificates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return CertificateCard(certificate: certificates[index]);
        },
      ),
    );
  }
}
