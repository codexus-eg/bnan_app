import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_registration_body_content.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationBody extends StatelessWidget {
  const TeacherRegistrationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: TeacherRegistrationBodyContent(),
    );
  }
}
