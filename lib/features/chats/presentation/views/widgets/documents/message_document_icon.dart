import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:flutter/material.dart';

IconData messageDocumentIcon(MessageDocumentItem item) {
  final mime = item.mimeType.toLowerCase();
  final name = item.fileName.toLowerCase();
  if (item.isExternalLink) return Icons.link;
  if (mime.startsWith('image/')) return Icons.image_outlined;
  if (mime.startsWith('video/')) return Icons.play_circle_outline;
  if (mime == 'application/pdf' || name.endsWith('.pdf')) {
    return Icons.picture_as_pdf_outlined;
  }
  if (mime.contains('spreadsheet') ||
      name.endsWith('.xls') ||
      name.endsWith('.xlsx')) {
    return Icons.table_chart_outlined;
  }
  if (mime.contains('presentation') ||
      name.endsWith('.ppt') ||
      name.endsWith('.pptx')) {
    return Icons.slideshow_outlined;
  }
  return Icons.description_outlined;
}
