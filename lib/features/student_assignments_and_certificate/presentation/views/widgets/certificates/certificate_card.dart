import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/utils/file_downloader.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_download_icon.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.certificate});

  final CertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          NetworkAttachmentPreview(
            attachmentUrl: certificate.previewImagePath,
            height: 146,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    certificateTitle(context, certificate),
                    style: StylesManager.styleBold14(context),
                  ),
                ),
                CertificateDownloadIcon(onTap: () => _download(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _download(BuildContext context) async {
    final s = S.of(context);
    if (certificate.pdfPath.isEmpty) {
      showCustomSnackBar(context, s.certificateFileUnavailable, false);
      return;
    }
    final success = await FileDownloader.download(
      url: certificate.pdfPath,
      fileName:
          '${certificate.certificateNumber.isEmpty ? 'certificate' : certificate.certificateNumber}.pdf',
    );
    if (!context.mounted) return;
    showCustomSnackBar(
      context,
      success ? s.fileDownloadedSuccessfully : s.unableToDownloadFile,
      success,
    );
  }
}
