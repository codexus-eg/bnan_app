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
    this.height = 37,
    this.maxLines = 2,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.isLoading = false,
    this.isLive = false,
  });

  final String text;
  final bool isHeader;
  final bool isDark;
  final bool isEvaluation;
  final double width;
  final double height;
  final int maxLines;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final bool hasText = text.isNotEmpty;

    final Color bgColor = isLive
        ? ColorManager.redFFF
        : _getBackgroundColor(hasText);
    final Color textColor = _getTextColor(hasText);

    return CustomTableCell(
      width: width,
      height: height,
      padding: padding,
      backgroundColor: bgColor,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Center(
          child: isLoading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: StylesManager.styleBold12(
                          context,
                        ).copyWith(color: textColor, height: 1.1),
                      ),
                    ),
                    if (isLive) ...[
                      const SizedBox(height: 2),
                      const Icon(
                        Icons.videocam_rounded,
                        size: 16,
                        color: ColorManager.redD8,
                      ),
                    ],
                  ],
                ),
        ),
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
