import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationScoreFields extends StatelessWidget {
  const EvaluationScoreFields({super.key, this.evaluation});

  final WeeklyEvaluationModel? evaluation;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: CustomTextField(label: s.attendance)),
            const SizedBox(width: 21),
            Expanded(child: CustomTextField(label: s.participation)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: CustomTextField(label: s.assignments)),
            const SizedBox(width: 21),
            Expanded(child: CustomTextField(label: s.behavior)),
          ],
        ),
      ],
    );
  }
}
