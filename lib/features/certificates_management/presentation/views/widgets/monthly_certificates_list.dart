import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_summary_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_card.dart';
import 'package:flutter/material.dart';

class MonthlyCertificatesList extends StatelessWidget {
  const MonthlyCertificatesList({
    super.key,
    required this.certificates,
  });

  final List<MonthlyCertificateSummaryModel> certificates;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        return CertificateCard(
          certificate: certificates[index],
        );
      },
    );
  }
}