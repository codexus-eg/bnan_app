import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_details.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReadOnlyGulfEvaluationStatus extends StatelessWidget {
  const ReadOnlyGulfEvaluationStatus({super.key, required this.classroom});
  final GulfEvaluationClassroomModel classroom;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return switch (classroom.evaluationStatus) {
      EvaluationAvailabilityStatus.evaluated
          when classroom.evaluation != null =>
        ReadOnlyEvaluationDetails(evaluation: classroom.evaluation!),
      EvaluationAvailabilityStatus.notEvaluated => Text(
        s.noEvaluationRecordedThisWeek,
        key: const Key('gulfNotEvaluated'),
      ),
      EvaluationAvailabilityStatus.notAvailable => Text(
        s.noValidSubjectForClassroom,
        key: const Key('gulfNotAvailable'),
      ),
      _ => Text(
        s.evaluationStatusUnavailable,
        key: const Key('gulfUnknownStatus'),
      ),
    };
  }
}
