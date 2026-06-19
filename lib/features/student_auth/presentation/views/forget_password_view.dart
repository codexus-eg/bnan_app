import 'package:bnan_app/features/student_auth/presentation/views/widgets/forget_password_widgets/forget_password_body.dart';
import 'package:flutter/material.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: ForgetPasswordBody(),
    );
  }
}
