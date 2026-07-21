import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateDialog extends StatelessWidget {
  const CertificateDialog({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: CertificateForm(
          title: isEdit
              ? S.of(context).editCertificate
              : S.of(context).issueNewCertificate,
        ),
      ),
    );
  }
}
