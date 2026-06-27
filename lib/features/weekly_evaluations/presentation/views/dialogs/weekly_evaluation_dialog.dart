import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationDialog extends StatelessWidget {
  const WeeklyEvaluationDialog({super.key, this.evaluation});

  final WeeklyEvaluationModel? evaluation;

  @override
  Widget build(BuildContext context) {
    final isEdit = evaluation != null;

    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: WeeklyEvaluationForm(
          title: isEdit
              ? S.of(context).editEvaluation
              : S.of(context).newWeeklyEvaluation,
          evaluation: evaluation,
        ),
      ),
    );
  }
}
