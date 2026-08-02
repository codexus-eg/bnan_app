import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_ui_text.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationCard extends StatelessWidget {
  const WeeklyEvaluationCard({
    super.key,
    required this.evaluation,
    this.headerAction,
  });

  final WeeklyEvaluationUiModel evaluation;
  final Widget? headerAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                evaluation.title,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor15),
              ),
            ),
            if (headerAction != null) headerAction!,
          ],
        ),
        const SizedBox(height: 8),
        if (evaluation.subjects.isEmpty)
          SizedBox(
            height: 138,
            child: NoDataWidget(
              title: EvaluationUiText.noStudentEvaluation(context),
            ),
          )
        else
          WeeklyEvaluationTable(subjects: evaluation.subjects),
      ],
    );
  }
}
