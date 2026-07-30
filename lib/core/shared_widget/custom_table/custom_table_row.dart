import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomTableRow extends StatelessWidget {
  const CustomTableRow({
    super.key,
    required this.children,
    this.equalHeight = false,
    this.showDivider = false,
    this.dividerColor = ColorManager.greyE8E9,
  });

  final List<Widget> children;
  final bool equalHeight;
  final bool showDivider;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: equalHeight
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: children,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (equalHeight) IntrinsicHeight(child: row) else row,
        if (showDivider)
          Column(
            children: [
              Divider(height: 1, thickness: 1, color: dividerColor),
              const SizedBox(height: 4),
            ],
          ),
      ],
    );
  }
}
