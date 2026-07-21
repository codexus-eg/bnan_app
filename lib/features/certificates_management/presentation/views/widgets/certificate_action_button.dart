import 'package:bnan_app/core/shared_widget/compact_action_button.dart';
import 'package:flutter/material.dart';

class CertificateActionButton extends StatelessWidget {
  const CertificateActionButton({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CompactActionButton(title: title, onTap: onTap);
  }
}
