import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ScheduleCell extends StatelessWidget {
  const ScheduleCell({
    super.key,
    required this.text,
    this.isHeader = false,
    this.isDark = false,
    this.isEvaluation = false,
    this.width = 64,
  });

  final String text;
  final bool isHeader;
  final bool isDark;
  final bool isEvaluation;
  final double width;

  @override
  Widget build(BuildContext context) {
    final bool hasText = text.isNotEmpty;

    final Color bgColor = _getBackgroundColor(hasText);
    final Color textColor = _getTextColor(hasText);

    return CustomTableCell(
      width: width,
      backgroundColor: bgColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: StylesManager.styleBold12(
          context,
        ).copyWith(color: textColor, height: 1.1),
      ),
    );
  }

  Color _getBackgroundColor(bool hasText) {
    if (!hasText) return ColorManager.white;

    if (isDark || isHeader) return ColorManager.mainColor14;

    if (isEvaluation) return ColorManager.white;

    return ColorManager.blueE3;
  }

  Color _getTextColor(bool hasText) {
    if (!hasText) return Colors.transparent;

    if (isDark || isHeader) return ColorManager.white;

    return ColorManager.mainColor14;
  }
}
