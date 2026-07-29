import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class LessonWeekDayItem extends StatelessWidget {
  const LessonWeekDayItem({
    super.key,
    required this.day,
    required this.number,
    this.isSelected = false,
  });

  final String day;
  final String number;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? ColorManager.mainColor14
        : ColorManager.greyA8AF;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 4,
        horizontal: 7.5,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? ColorManager.secondaryColor.withAlpha((255 * .2).round())
            : ColorManager.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: foreground),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: foreground),
          ),
          const SizedBox(height: 4),
          Text(
            number,
            style: StylesManager.styleMedium16(
              context,
            ).copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
