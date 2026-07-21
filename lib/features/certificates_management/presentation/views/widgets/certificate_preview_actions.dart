import 'package:bnan_app/core/shared_widget/document_preview_actions.dart';
import 'package:flutter/material.dart';

class CertificatePreviewActions extends StatelessWidget {
  const CertificatePreviewActions({super.key, required this.pdfUrl});
  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return  DocumentPreviewActions(pdfUrl:pdfUrl);
  }
}
