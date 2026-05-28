import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key, required this.onSuccess});

  final void Function(String email) onSuccess;

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomAuthTextField(
          label: S.of(context).email,
          hintText: '',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomAppButton(
          text: S.of(context).sendResetCode,
          onPressed: () => widget.onSuccess(emailController.text.trim()),
        ),
      ],
    );
  }
}