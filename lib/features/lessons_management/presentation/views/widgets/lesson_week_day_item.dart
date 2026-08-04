import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class LessonWeekDayItem extends StatelessWidget {
  const LessonWeekDayItem({
    super.key,
    required this.day,
    required this.onTap,
    this.isSelected = false,
  });

  final String day;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? ColorManager.mainColor14
        : ColorManager.greyA8AF;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.secondaryColor.withAlpha((255 * .2).round())
              : ColorManager.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: foreground),
        ),
        child: Text(
          day,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: foreground),
        ),
      ),
    );
  }
}
