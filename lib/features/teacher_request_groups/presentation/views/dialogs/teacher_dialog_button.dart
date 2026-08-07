import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherDialogButton extends StatelessWidget {
  const TeacherDialogButton({
    super.key,
    required this.title,
    required this.isPrimary,
    this.onTap,
    this.isLoading = false,
  });

  final String title;
  final bool isPrimary;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary
        ? ColorManager.white
        : ColorManager.mainColor14;
    return CustomAppButton(
      text: title,
      height: 30,
      isLoading: isLoading,
      onPressed: onTap,
      backgroundColor: isPrimary
          ? ColorManager.mainColor14
          : ColorManager.greyA8AF,
      textColor: foreground,
      style: StylesManager.styleBold12(context).copyWith(color: foreground),
    );
  }
}
