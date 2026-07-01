import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AdminPlaceholderTab extends StatelessWidget {
  const AdminPlaceholderTab({
    super.key,
    required this.title,
    required this.onMenuTap,
  });

  final String title;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: StylesManager.styleBold20(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
      ),
    );
  }
}
