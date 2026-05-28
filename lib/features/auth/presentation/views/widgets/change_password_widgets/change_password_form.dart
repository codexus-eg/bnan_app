import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAuthTextField(
          label: S.of(context).newPassword,
          hintText: S.of(context).passwordHint,
          obscureText: true,
          suffixIcon: const Icon(
            Icons.visibility_outlined,
            size: 24,
            color: ColorManager.greyA8AF,
          ),
        ),
        const SizedBox(height: 16),
        CustomAuthTextField(
          label: S.of(context).confirmNewPassword,
          hintText: S.of(context).passwordHint,
          obscureText: true,
          suffixIcon: const Icon(
            Icons.visibility_outlined,
            size: 24,
            color: ColorManager.greyA8AF,
          ),
        ),
        const SizedBox(height: 16),
        CustomAppButton(
          text: S.of(context).confirm,
          onPressed: () {
            MyNavigator.goToOff(context, Routes.logIn);
          },
        ),
      ],
    );
  }
}