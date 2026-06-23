import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_grades_subjects_data/check_icon.dart';
import 'package:flutter/material.dart';

class CustomOption extends StatelessWidget {
  const CustomOption({
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
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorManager.blueD0DE),
        ),
        child: Row(
          children: [
            CheckIcon(isSelected: isSelected),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: StylesManager.styleRegular16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
