import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/change_password_widgets/change_password_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key, required this.email});
    final String email;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(headerText: S.of(context).changePassword,iconNeeded: false),
      body: ChangePasswordBody(email:email),
    );
  }
}
