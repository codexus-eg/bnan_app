import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_graduation_grade_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_graduation_year_field.dart';
import 'package:flutter/material.dart';

class TeacherGraduationInfoFields extends StatelessWidget {
  const TeacherGraduationInfoFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: TeacherGraduationYearField()),
        SizedBox(width: 23),
        Expanded(child: TeacherGraduationGradeField()),
      ],
    );
  }
}
