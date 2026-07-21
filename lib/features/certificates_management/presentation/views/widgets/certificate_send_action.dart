import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/issue_monthly_certificates_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificatesSendActions extends StatelessWidget {
  const CertificatesSendActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16, end: 16, start: 16),
      child: Row(
        children: [
          IssueMonthlyCertificatesWidget(),
          const SizedBox(width: 19),
          Expanded(
            child: AddNewTopicButton(
              title: S.of(context).issueNewCertificate,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const CertificateDialog(),
                );
              },
              path: ImageManager.plus,
            ),
          ),
        ],
      ),
    );
  }
}
