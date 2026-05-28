import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/forget_password_form.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/forget_password_subtitle.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/forget_password_verification_form.dart';
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
  bool isCodeSent = false;
  String email = '';

  void showVerification(String userEmail) {
    setState(() {
      email = userEmail;
      isCodeSent = true;
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(
                    title: S.of(context).forgotPasswordTitle,
                    subtitle: null,
                  ),
                  const SizedBox(height: 8),
                  ForgetPasswordSubtitle(
                    isCodeSent: isCodeSent,
                    email: email,
                  ),
                  const SizedBox(height: 28),
                  isCodeSent
                      ? const ForgetPasswordVerificationForm()
                      : ForgetPasswordForm(onSuccess: showVerification),
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