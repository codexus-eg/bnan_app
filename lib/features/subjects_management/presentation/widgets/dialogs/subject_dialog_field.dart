import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SubjectDialogField extends StatelessWidget {
  const SubjectDialogField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      hintStyle: StylesManager.styleMedium16(
        context,
      ).copyWith(color: ColorManager.mainColor14),
      backgroundColor: ColorManager.white,
    );
  }
}
