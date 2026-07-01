import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.mode});

  final FormMode mode;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      label: mode == FormMode.password ? s.newPassword : s.password,
      hintText: s.atLeastSixChars,
      obscureText: true,
      suffixIcon: const Icon(
        Icons.visibility_outlined,
        color: ColorManager.greyA8AF,
      ),
    );
  }
}
