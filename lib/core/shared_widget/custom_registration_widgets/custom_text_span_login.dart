import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_registration_widgets/auth_switch_text.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomTextSpanLogin extends StatelessWidget {
  const CustomTextSpanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSwitchText(
      normalText: S.of(context).alreadyHaveAccount,
      actionText: S.of(context).loginNow,
      onTap: () => MyNavigator.goToOffAll(context, Routes.logIn),
    );
  }
}
