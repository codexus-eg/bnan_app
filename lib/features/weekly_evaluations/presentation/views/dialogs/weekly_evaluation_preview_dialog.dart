import 'package:bnan_app/core/shared_widget/document_preview_actions.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/preview_image.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationPreviewDialog extends StatelessWidget {
  const WeeklyEvaluationPreviewDialog({super.key, required this.evaluation});

  final WeeklyEvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreviewImage(imageUrl: evaluation.previewImage),
          const SizedBox(height: 16),
          const DocumentPreviewActions(),
        ],
      ),
    );
  }
}
