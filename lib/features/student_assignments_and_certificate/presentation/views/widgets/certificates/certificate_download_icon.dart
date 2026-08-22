import 'package:bnan_app/core/shared_widget/download_icon_button.dart';
import 'package:flutter/material.dart';

class CertificateDownloadIcon extends StatelessWidget {
  const CertificateDownloadIcon({
    super.key,
    required this.url,
    required this.fileName,
  });

  final String url;
  final String fileName;

  @override
  Widget build(BuildContext context) =>
      DownloadIconButton(url: url, fileName: fileName);
}
