import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/schedule_fields.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/subjects_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentInfoStep extends StatelessWidget {
  const StudentInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(S.of(context).studentInfo),
        const SizedBox(height: 14),
        CustomAuthTextField(label: S.of(context).studentName, hintText: ''),
        const SizedBox(height: 12),
        CustomAuthTextField(
          label: S.of(context).grade,
          hintText: S.of(context).selectGrade,
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
        ),
        const SizedBox(height: 14),
        const SubjectsList(),
        const SizedBox(height: 14),
        CustomAuthTextField(label: S.of(context).studentUsername, hintText: ''),
        const SizedBox(height: 12),
        CustomAuthTextField(
          label: S.of(context).studentPasswordField,
          hintText: '',
        ),
        const SizedBox(height: 14),
        const ScheduleFields(),
      ],
    );
  }
}