import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomAuthTextField(
          label: S.of(context).email,
          hintText: '',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomAuthTextField(
          label: S.of(context).password,
          hintText: S.of(context).passwordHint,
          obscureText: true,
          suffixIcon: const Icon(
            Icons.visibility_outlined,
            size: 24,
            color: ColorManager.greyA8AF,
          ),
        ),
        TextButton(
          onPressed: () {
            MyNavigator.goTo(context, Routes.forgetPassword);
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            S.of(context).forgotPassword,
            style: StylesManager.styleBold12(context).copyWith(
              color: ColorManager.secondaryColor,
            ),
          ),
        ),
        // const SizedBox(height: 16),
        CustomAppButton(
          text: S.of(context).login,
          onPressed: () {
          },
        ),
      ],
    );
  }
}