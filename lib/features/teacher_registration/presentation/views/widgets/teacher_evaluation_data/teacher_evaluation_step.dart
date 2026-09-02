import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_evaluation_data/teacher_evaluation_text_fields.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_evaluation_data/teacher_trial_lesson_question.dart';
import 'package:flutter/material.dart';

class TeacherEvaluationStep extends StatelessWidget {
  const TeacherEvaluationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TeacherTrialLessonQuestion(),
        SizedBox(height: 16),
        TeacherEvaluationTextFields(),
      ],
    );
  }
}
