import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_meta.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReadOnlyEgyptianHeader extends StatelessWidget {
  const ReadOnlyEgyptianHeader({super.key, required this.data});
  final MeWeeklyEvaluationsDataModel data;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDetailsWidgetBackground(
      key: const Key('egyptianEvaluationHeader'),
      padding: const EdgeInsetsDirectional.all(12),
      child: Column(
        children: [
          ReadOnlyEvaluationMeta(
            label: s.classroom,
            value: data.classroom?.name,
          ),
          ReadOnlyEvaluationMeta(label: s.grade, value: data.grade?.name),
          ReadOnlyEvaluationMeta(
            label: s.curriculum,
            value: data.curriculum?.name,
          ),
        ],
      ),
    );
  }
}
