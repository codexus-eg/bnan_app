import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentRegisterPasswordField extends StatefulWidget {
  const ParentRegisterPasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<ParentRegisterPasswordField> createState() =>
      _ParentRegisterPasswordFieldState();
}

class _ParentRegisterPasswordFieldState
    extends State<ParentRegisterPasswordField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      label: s.dashboardPassword,
      hintText: s.passwordHint,
      controller: widget.controller,
      obscureText: obscurePassword,
      isRequired: true,
      validator: (value) => MyValidator.minLengthValidator(
        value: value,
        minLength: 6,
        emptyMessage: s.passwordCannotBeEmpty,
        minMessage: s.parentPasswordMinLength,
      ),
      suffixIcon: IconButton(
        onPressed: () => setState(() => obscurePassword = !obscurePassword),
        icon: Icon(
          obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: ColorManager.greyA8AF,
        ),
      ),
    );
  }
}
