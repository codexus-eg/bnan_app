import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SubjectDialogField extends StatelessWidget {
  const SubjectDialogField({super.key, required this.label, this.controller});

  final String label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      hintStyle: StylesManager.styleMedium16(
        context,
      ).copyWith(color: ColorManager.mainColor14),
      backgroundColor: ColorManager.white,
    );
  }
}
