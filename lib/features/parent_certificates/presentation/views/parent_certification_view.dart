import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_certificates/presentation/views/widgets/parent_certificates_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentCertificationView extends StatelessWidget {
  const ParentCertificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).certificates),
      body: ParentCertificatesBody(),
    );
  }
}