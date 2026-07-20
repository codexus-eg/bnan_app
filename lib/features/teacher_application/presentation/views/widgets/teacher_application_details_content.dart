import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/bnan_teaching_details_section.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/evaluation_details_section.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/experience_details_section.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/personal_details_section.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/qualification_details_section.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/technical_skills_details_section.dart';
import 'package:flutter/material.dart';

class TeacherApplicationDetailsContent extends StatelessWidget {
  const TeacherApplicationDetailsContent({
    super.key,
    required this.teacher,
  });

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final sections = [
      PersonalDetailsSection(teacher: teacher),
      QualificationDetailsSection(teacher: teacher),
      ExperienceDetailsSection(teacher: teacher),
      BnanTeachingDetailsSection(teacher: teacher),
      TechnicalSkillsDetailsSection(teacher: teacher),
      EvaluationDetailsSection(teacher: teacher),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          sections[index],
          if (index != sections.length - 1) const SizedBox(height: 0),
        ],
      ],
    );
  }
}