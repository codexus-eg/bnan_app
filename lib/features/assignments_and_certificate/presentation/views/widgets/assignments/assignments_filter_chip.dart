import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AssignmentsFilterChip extends StatelessWidget {
  const AssignmentsFilterChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.mainColor14 : ColorManager.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorManager.mainColor14),
        ),
        child: Text(
          title,
          style: StylesManager.styleBold16(context).copyWith(
            color: isSelected ? ColorManager.white : ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}