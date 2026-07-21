import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificates_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificatesManagementView extends StatelessWidget {
  const CertificatesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).certificates,
        iconNeeded: true,
      ),
      body: CertificatesManagementBody(),
    );
  }
}
