import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_download_icon.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificate_title.dart';
import 'package:flutter/material.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.certificate});

  final CertificateModel certificate;

  @override
  Widget build(BuildContext context) {
    final downloadUrl = certificate.pdfPath.trim().isNotEmpty
        ? certificate.pdfPath
        : certificate.previewImagePath;
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: NetworkAttachmentPreview(
                attachmentUrl: certificate.previewImagePath,
                height: double.infinity,
                fit: BoxFit.contain,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
            ),
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
                if (downloadUrl.trim().isNotEmpty)
                  CertificateDownloadIcon(
                    url: downloadUrl,
                    fileName: _downloadName(downloadUrl),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _downloadName(String url) {
    final extension = certificate.pdfPath.trim().isNotEmpty
        ? 'pdf'
        : _imageExtension(url);
    return 'Bnan_Certificate_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }

  String _imageExtension(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? '';
    if (path.endsWith('.png')) return 'png';
    if (path.endsWith('.jpeg')) return 'jpeg';
    if (path.endsWith('.webp')) return 'webp';
    return 'jpg';
  }
}
