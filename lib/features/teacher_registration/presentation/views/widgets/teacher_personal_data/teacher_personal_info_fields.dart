import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_account_fields.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_contact_fields.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_location_fields.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_birth_date_field.dart';
import 'package:flutter/material.dart';

class TeacherPersonalInfoFields extends StatelessWidget {
  const TeacherPersonalInfoFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TeacherContactFields(),
        SizedBox(height: 16),
        TeacherAccountFields(),
        SizedBox(height: 16),
        TeacherBirthDateField(),
        SizedBox(height: 16),
        TeacherLocationFields(),
      ],
    );
  }
}
