import 'package:bnan_app/core/shared_widget/download_icon_button.dart';
import 'package:flutter/material.dart';

class ReceiptDownloadButton extends StatelessWidget {
  const ReceiptDownloadButton({super.key, required this.receiptUrl});

  final String receiptUrl;

  @override
  Widget build(BuildContext context) {
    return DownloadIconButton(
      url: receiptUrl,
      fileName: _fileName(receiptUrl, 'payment_receipt'),
    );
  }

  String _fileName(String value, String fallback) {
    final segments = Uri.tryParse(value)?.pathSegments;
    return segments?.isNotEmpty == true ? segments!.last : fallback;
  }
}
