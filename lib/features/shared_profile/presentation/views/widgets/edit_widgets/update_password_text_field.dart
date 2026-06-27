import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class UpdatePasswordTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onVisibilityTap;
  final String? Function(String?)? validator;

  const UpdatePasswordTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onVisibilityTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      obscureText: obscureText,
      validator: validator,
      suffixIcon: IconButton(
        onPressed: onVisibilityTap,
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 24,
          color: ColorManager.greyA8AF,
        ),
      ),
    );
  }
}