import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_value_label.dart';
import 'package:flutter/widgets.dart';

List<WeeklyEvaluationSubjectUiModel> mapGulfReadOnlyRows(
  BuildContext context,
  MeWeeklyEvaluationsDataModel data,
) => data.classrooms.where((item) => item.subject != null).map((item) {
  final evaluation = item.evaluation;
  return _row(
    context,
    id: item.subject!.id.isEmpty ? item.id : item.subject!.id,
    name: item.subject!.name,
    evaluation: evaluation,
    evaluated: evaluation != null,
  );
}).toList(growable: false);

List<WeeklyEvaluationSubjectUiModel> mapEgyptianReadOnlyRows(
  BuildContext context,
  MeWeeklyEvaluationsDataModel data,
) => data.subjects.map((item) {
  return _row(
    context,
    id: item.id,
    name: item.name,
    evaluation: item.evaluation,
    evaluated: item.isEvaluated,
  );
}).toList(growable: false);

WeeklyEvaluationSubjectUiModel _row(
  BuildContext context, {
  required String id,
  required String name,
  required MeEvaluationValueModel? evaluation,
  required bool evaluated,
}) => WeeklyEvaluationSubjectUiModel(
  id: id,
  subjectName: name,
  attendance: evaluated
      ? formatReadOnlyAttendance(
          context: context,
          attendanceStatus: evaluation?.attendance,
          attended: evaluation?.attendanceAttended,
          total: evaluation?.attendanceTotal,
        )
      : '-',
  participation: evaluated
      ? readOnlyEvaluationValueLabel(context, evaluation?.participation)
      : '-',
  homework: evaluated
      ? readOnlyEvaluationValueLabel(context, evaluation?.homework)
      : '-',
  behavior: evaluated
      ? readOnlyEvaluationValueLabel(context, evaluation?.behavior)
      : '-',
  notes: evaluated && evaluation?.notes?.trim().isNotEmpty == true
      ? evaluation!.notes!.trim()
      : '-',
  isEvaluated: evaluated,
);
