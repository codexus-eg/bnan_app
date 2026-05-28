import 'package:bnan_app/features/auth/presentation/views/widgets/change_password_widgets/change_password_body.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_appbar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAuthAppbar(title: S.of(context).changePassword),
      body: ChangePasswordBody(),
    );
  }
}
