import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_registration_body.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationView extends StatelessWidget {
  const TeacherRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: TeacherRegistrationBody(),
      ),
    );
  }
}
