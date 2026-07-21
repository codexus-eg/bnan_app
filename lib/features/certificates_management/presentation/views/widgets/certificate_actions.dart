import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_summary_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_preview_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_action_button.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/delete_certificates_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateActions extends StatelessWidget {
  const CertificateActions({
    super.key,
    required this.certificate,
  });

  final MonthlyCertificateSummaryModel certificate;

  @override
  Widget build(BuildContext context) {
    final studentName = certificate.studentName?.trim();
    final certificateId = certificate.id?.trim();

    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName?.isNotEmpty == true
                      ? studentName!
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold12(context).copyWith(
                    color: ColorManager.greyA8AF,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  certificate.gradeName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleRegular10(context).copyWith(
                    color: ColorManager.mainColor14,
                  ),
                ),
              ],
            ),
          ),
          CertificateActionButton(
            title: S.of(context).preview,
            onTap: () => _showPreview(context),
          ),
          const SizedBox(width: 17),
          CertificateActionButton(
            title: S.of(context).edit,
            onTap: () => _showEditDialog(context),
          ),
          const SizedBox(width: 17),
          if (certificateId?.isNotEmpty == true)
            DeleteCertificatesSection(
              certificateId: certificateId!,
            ),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha((255 * .72).round()),
      builder: (_) => CertificatePreviewDialog(
        imageUrl: certificate.previewImagePath ?? '',
        pdfUrl: certificate.previewImagePath??'',
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CertificateDialog(isEdit: true),
    );
  }
}