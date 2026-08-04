import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeleteLessonButton extends StatelessWidget {
  const DeleteLessonButton({super.key, this.onPressed, this.isLoading = false});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      text: S.of(context).delete,
      backgroundColor: ColorManager.red,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
