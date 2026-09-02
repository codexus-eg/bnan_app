import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherAnswerButton extends StatelessWidget {
  const TeacherAnswerButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 32,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isSelected ? ColorManager.mainColor14 : Colors.white,
          side: BorderSide(
            color: isSelected
                ? ColorManager.mainColor14
                : ColorManager.blueE3,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: StylesManager.styleRegular16(context).copyWith(
            color: isSelected ? Colors.white : ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}
