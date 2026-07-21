import 'package:bnan_app/core/shared_widget/document_preview_action_button.dart';
import 'package:flutter/material.dart';

class CertificatePreviewButton extends StatelessWidget {
  const CertificatePreviewButton({
    super.key,
    required this.title,
    this.icon,
    this.isPrimary = false,
    this.onTap,
    this.imageUrl,
  });

  final String title;
  final IconData? icon;
  final String? imageUrl;

  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DocumentPreviewActionButton(
      title: title,
      icon: icon,
      imageUrl: imageUrl,
      isPrimary: isPrimary,
      onTap: onTap,
    );
  }
}
