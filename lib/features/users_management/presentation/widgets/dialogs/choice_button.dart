import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      text: text,
      height: 36,
      isLoading: isLoading,
      style: StylesManager.styleRegular16(
        context,
      ).copyWith(color: ColorManager.mainColor15),
      backgroundColor: ColorManager.white,
      borderColor: ColorManager.blueE3,
      onPressed: onPressed,
    );
  }
}
