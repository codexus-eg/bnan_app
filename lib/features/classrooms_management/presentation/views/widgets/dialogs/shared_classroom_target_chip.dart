import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SharedClassroomTargetChip extends StatelessWidget {
  const SharedClassroomTargetChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.blue3A : ColorManager.greyD9D9.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? ColorManager.blue3A : ColorManager.greyD9D9),
        ),
        child: Text(
          label,
          style: StylesManager.styleRegular12(context).copyWith(
            color: isSelected ? ColorManager.white : ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}
