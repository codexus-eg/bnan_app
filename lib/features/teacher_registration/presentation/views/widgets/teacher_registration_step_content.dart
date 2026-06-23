import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_attachments_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_evaluation_data/teacher_evaluation_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_experience_data/teacher_experience_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_grades_subjects_data/teacher_grades_options_list.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_personal_data/teacher_personal_info_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_qualification_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_teaching_details_data/teacher_teaching_details_step.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_technical_skills_data/teacher_technical_skills_step.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationStepContent extends StatelessWidget {
  const TeacherRegistrationStepContent({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 1:
        return TeacherPersonalInfoStep();
      case 2:
        return const TeacherQualificationStep();
      case 3:
        return const TeacherExperienceStep();
      case 4:
        return const TeacherTeachingDetailsStep();
      case 5:
        return const TeacherGradesOptionsList();
      case 6:
        return const TeacherTechnicalSkillsStep();
      case 7:
        return const TeacherEvaluationStep();
      case 8:
        return const TeacherAttachmentsStep();
      default:
        return const SizedBox();
    }
  }
}
