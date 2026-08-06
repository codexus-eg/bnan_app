import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_card_text.dart';
import 'package:flutter/material.dart';

class DocumentCardShell extends StatelessWidget {
  const DocumentCardShell({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.preview,
    this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final String? preview;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
    child: CustomDetailsWidgetBackground(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.blueE3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorManager.mainColor14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DocumentCardText(
              title: title,
              subtitle: subtitle,
              preview: preview,
            ),
          ),
          const Icon(Icons.chevron_right, color: ColorManager.greyA8AF),
        ],
      ),
    ),
  );
}
