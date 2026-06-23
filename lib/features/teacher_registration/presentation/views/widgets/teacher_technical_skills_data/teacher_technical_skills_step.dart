import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_technical_skills_data/teacher_technical_apps_level.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_technical_skills_data/teacher_technical_questions.dart';
import 'package:flutter/material.dart';

class TeacherTechnicalSkillsStep extends StatelessWidget {
  const TeacherTechnicalSkillsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherTechnicalAppsLevel(),
        SizedBox(height: 16),
        TeacherTechnicalQuestions(),
      ],
    );
  }
}