import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/forget_password_widgets/forget_password_form.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/forget_password_widgets/forget_password_subtitle.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/forget_password_widgets/forget_password_verification_form.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/shared_widgets/auth_header.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/shared_widgets/bnan_footer.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key, required this.args});

  final OtpFlowArgs args;

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  late bool isCodeSent;
  late String email;

  @override
  void initState() {
    super.initState();
    isCodeSent = widget.args.isAccountVerification;
    email = widget.args.email;
  }

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
                    title: widget.args.isAccountVerification
                        ? S.of(context).verifyAccountTitle
                        : S.of(context).forgotPasswordTitle,
                    subtitle: null,
                  ),
                  const SizedBox(height: 8),
                  ForgetPasswordSubtitle(
                    isCodeSent: isCodeSent,
                    email: email,
                    isAccountVerification: widget.args.isAccountVerification,
                  ),
                  const SizedBox(height: 28),
                  isCodeSent
                      ? ForgetPasswordVerificationForm(args: widget.args)
                      : ForgetPasswordForm(onSuccess: showVerification),
                  const Spacer(),
                  const BnanFooter(),
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
