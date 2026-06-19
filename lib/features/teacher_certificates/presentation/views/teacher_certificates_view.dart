import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/teacher_certificates_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherCertificatesView extends StatelessWidget {
  const TeacherCertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).certificates,
        iconNeeded: true,
      ),
      body: TeacherCertificatesBody(),
    );
  }
}
