import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_details.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EgyptianEvaluationSubjectCard extends StatelessWidget {
  const EgyptianEvaluationSubjectCard({super.key, required this.subject});
  final MeEvaluationSubjectModel subject;

  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    padding: const EdgeInsetsDirectional.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold16(context),
        ),
        const SizedBox(height: 8),
        if (subject.isEvaluated)
          ReadOnlyEvaluationDetails(evaluation: subject.evaluation!)
        else
          Text(
            S.of(context).noSubjectEvaluationRecordedThisWeek,
            key: const Key('egyptianNotEvaluated'),
          ),
      ],
    ),
  );
}
