import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/forget_password_form.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/forget_password_success_card.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_footer.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  bool isLinkSent = false;
  String email = '';

  void showSuccess(String userEmail) {
    setState(() {
      email = userEmail;
      isLinkSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(
                    title: S.of(context).forgotPasswordTitle,
                    subtitle: S.of(context).forgotPasswordSubtitle,
                  ),
                  const SizedBox(height: 22),
                  isLinkSent
                      ? ForgetPasswordSuccessCard(email: 'bnan@gmail.com')
                      : ForgetPasswordForm(onSuccess: showSuccess),
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