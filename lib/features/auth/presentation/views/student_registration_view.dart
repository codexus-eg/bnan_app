import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/student_registration_body.dart';
import 'package:flutter/material.dart';

class StudentRegistrationView extends StatelessWidget {
  const StudentRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: StudentRegistrationBody(),
    );
  }
}
