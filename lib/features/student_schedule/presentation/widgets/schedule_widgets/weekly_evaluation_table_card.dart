import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationTableCard extends StatelessWidget {
  const WeeklyEvaluationTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final subjects = [
      WeeklyEvaluationSubjectUiModel(
        subjectName: s.arabicLanguage,
        attendance: s.absent,
        participation: s.excellent,
        homework: s.excellent,
        notes: '-',
      ),
      WeeklyEvaluationSubjectUiModel(
        subjectName: s.english,
        attendance: '-',
        participation: '-',
        homework: '-',
        notes: '-',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.weeklyEvaluation,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor15),
        ),
        const SizedBox(height: 8),
        WeeklyEvaluationTable(subjects: subjects),
      ],
    );
  }
}
