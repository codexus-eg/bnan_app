import 'package:bnan_app/features/auth/presentation/views/widgets/change_password_widgets/change_password_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            ChangePasswordForm(),
          ],
        ),
      ),
    );
  }
}