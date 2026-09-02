import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_answer_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherYesNoAnswers extends StatelessWidget {
  const TeacherYesNoAnswers({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TeacherAnswerButton(
          text: S.of(context).yes,
          isSelected: value == true,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 12),
        TeacherAnswerButton(
          text: S.of(context).no,
          isSelected: value == false,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}
