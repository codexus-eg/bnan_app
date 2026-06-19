import 'package:bnan_app/features/student_auth/presentation/views/widgets/change_password_widgets/change_password_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            ChangePasswordForm(email: email),
          ],
        ),
      ),
    );
  }
}