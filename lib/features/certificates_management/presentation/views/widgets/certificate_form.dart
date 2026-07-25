import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_create_form.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_edit_form.dart';
import 'package:flutter/material.dart';

class CertificateForm extends StatelessWidget {
  const CertificateForm({
    super.key,
    required this.title,
    this.certificateId,
  });

  final String title;
  final String? certificateId;

  bool get isEdit => certificateId?.trim().isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      return CertificateEditForm(
        title: title,
        certificateId: certificateId!.trim(),
      );
    }

    return CertificateCreateForm(
      title: title,
    );
  }
}