import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: ColorManager.mainColor14.withValues(alpha: .45)),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: StylesManager.styleBold18(context)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: StylesManager.styleRegular14(context)),
          ],
        ),
      ),
    );
  }
}