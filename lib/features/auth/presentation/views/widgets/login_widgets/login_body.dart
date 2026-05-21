import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/login_widgets/login_form.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_footer.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_header.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_switch_text.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(
                    title: S.of(context).loginWelcomeTitle,
                    subtitle: S.of(context).loginWelcomeSubtitle,
                  ),
                  const SizedBox(height: 16),
                  const LoginForm(),
                  const SizedBox(height: 16),
                  AuthSwitchText(
                    normalText: S.of(context).doNotHaveAccount,
                    actionText: S.of(context).createAccount,
                    onTap: () {
                      MyNavigator.goTo(context, Routes.register);
                    },
                  ),
                  const Spacer(),
                  const AuthFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}