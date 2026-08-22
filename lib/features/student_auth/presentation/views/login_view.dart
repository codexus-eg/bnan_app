import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/login_widgets/login_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.showEgyptianRegistrationSuccess = false});

  final bool showEgyptianRegistrationSuccess;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    if (widget.showEgyptianRegistrationSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCustomSnackBar(
          context,
          S.of(context).egyptianStudentRegistrationSuccessMessage,
          true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(resizeToAvoidBottomInset: false, body: LoginBody());
  }
}
