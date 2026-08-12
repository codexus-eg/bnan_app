import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificates_content.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_send_action.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/choose_classroom_certificate.dart';
import 'package:flutter/material.dart';

class CertificatesManagementBody extends StatelessWidget {
  const CertificatesManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CertificatesSendActions(),
        ChooseClassroomCertificate(),
        Expanded(child: CertificatesContent()),
      ],
    );
  }
}
