import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_yes_no_answers.dart';
import 'package:flutter/material.dart';

class TeacherYesNoQuestion extends StatelessWidget {
  const TeacherYesNoQuestion({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
    this.isRequired = true,
  });

  final String question;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherQuestionTitle(question: question, isRequired: isRequired),
        const SizedBox(height: 8),
        TeacherYesNoAnswers(value: value, onChanged: onChanged),
      ],
    );
  }
}
