import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DiscountCodeBadge extends StatelessWidget {
  const DiscountCodeBadge({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: StylesManager.styleBold12(context).copyWith(color: color),
      ),
    );
  }
}
