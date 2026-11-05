import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_detail_row.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_value_label.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ReadOnlyEvaluationDetails extends StatelessWidget {
  const ReadOnlyEvaluationDetails({super.key, required this.evaluation});
  final MeEvaluationValueModel evaluation;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rows = [
      (
        s.attendance,
        formatReadOnlyAttendance(
          context: context,
          attendanceStatus: evaluation.attendance,
          attended: evaluation.attendanceAttended,
          total: evaluation.attendanceTotal,
        ),
      ),
      (
        s.participation,
        readOnlyEvaluationValueLabel(context, evaluation.participation),
      ),
      (
        s.homeworkLabel,
        readOnlyEvaluationValueLabel(context, evaluation.homework),
      ),
      (s.behavior, readOnlyEvaluationValueLabel(context, evaluation.behavior)),
      (
        s.notesText,
        evaluation.notes?.trim().isNotEmpty == true
            ? evaluation.notes!.trim()
            : '-',
      ),
    ];
    return Column(
      key: const Key('readOnlyEvaluationDetails'),
      children: [
        for (final row in rows)
          ReadOnlyEvaluationDetailRow(label: row.$1, value: row.$2),
      ],
    );
  }
}
