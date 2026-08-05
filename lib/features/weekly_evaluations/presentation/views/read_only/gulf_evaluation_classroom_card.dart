import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_meta.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_gulf_evaluation_status.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GulfEvaluationClassroomCard extends StatelessWidget {
  const GulfEvaluationClassroomCard({super.key, required this.classroom});
  final GulfEvaluationClassroomModel classroom;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsetsDirectional.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classroom.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold16(context),
          ),
          const SizedBox(height: 8),
          ReadOnlyEvaluationMeta(
            label: s.subject,
            value: classroom.subject?.name,
          ),
          ReadOnlyEvaluationMeta(label: s.grade, value: classroom.grade?.name),
          ReadOnlyEvaluationMeta(
            label: s.curriculum,
            value: classroom.curriculum?.name,
          ),
          const SizedBox(height: 8),
          ReadOnlyGulfEvaluationStatus(classroom: classroom),
        ],
      ),
    );
  }
}
