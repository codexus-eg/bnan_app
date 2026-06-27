import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_actions.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_preview_image.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationCard extends StatelessWidget {
  const WeeklyEvaluationCard({super.key, required this.evaluation});

  final WeeklyEvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          WeeklyEvaluationPreviewImage(imageUrl: evaluation.previewImage),
          WeeklyEvaluationActions(evaluation: evaluation),
        ],
      ),
    );
  }
}
