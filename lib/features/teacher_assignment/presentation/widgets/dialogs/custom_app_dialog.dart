import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomAppDialog extends StatelessWidget {
  const CustomAppDialog({
    super.key,
    required this.child,
    this.width,
  });

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),

      backgroundColor: ColorManager.greyF8F9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width ?? 311,
        ),
        child: child,
      ),
    );
  }
}