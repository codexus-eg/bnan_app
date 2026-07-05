import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.mode,
    required this.controller,
    this.obscureText = true,
    required this.onToggleVisibility,
    this.validator,
  });

  final FormMode mode;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      label: mode == FormMode.password ? s.newPassword : s.password,
      hintText: s.atLeastSixChars,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      suffixIcon: GestureDetector(
        onTap: onToggleVisibility,
        child: Icon(
          obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: ColorManager.greyA8AF,
        ),
      ),
    );
  }
}
