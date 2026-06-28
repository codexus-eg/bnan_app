import 'package:bnan_app/core/shared_widget/compact_action_button.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_preview_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationActionButtons extends StatelessWidget {
  const WeeklyEvaluationActionButtons({super.key, required this.evaluation});

  final WeeklyEvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CompactActionButton(
          title: S.of(context).edit,
          onTap: () => showDialog(
            context: context,
            builder: (_) => WeeklyEvaluationDialog(evaluation: evaluation),
          ),
        ),
        const SizedBox(width: 17),
        CompactActionButton(
          title: S.of(context).preview,
          onTap: () => showDialog(
            context: context,
            barrierColor: Colors.black.withAlpha((255 * .72).round()),
            builder: (_) =>
                WeeklyEvaluationPreviewDialog(evaluation: evaluation),
          ),
        ),
      ],
    );
  }
}
