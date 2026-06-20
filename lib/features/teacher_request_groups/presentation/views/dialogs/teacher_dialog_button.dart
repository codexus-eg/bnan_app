import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherDialogButton extends StatelessWidget {
  const TeacherDialogButton({
    super.key,
    required this.title,
    required this.isPrimary,
    this.onTap,
  });

  final String title;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isPrimary
              ? ColorManager.mainColor14
              : ColorManager.greyA8AF,
          foregroundColor: isPrimary
              ? ColorManager.white
              : ColorManager.mainColor14,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: StylesManager.styleBold12(context).copyWith(
            color: isPrimary ? ColorManager.white : ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}
