import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';

WeeklyEvaluationUiModel mapWeeklyEvaluationToUi(
  S s,
  WeeklyEvaluationModel evaluation, {
  required String title,
  required int index,
}) {
  return WeeklyEvaluationUiModel(
    id: '${evaluation.studentName}-${evaluation.weekStart}-$index',
    title: title,
    studentName: evaluation.studentName,
    classroomName: evaluation.classLabel,
    weekStart: evaluation.weekStart,
    subjects: [
      WeeklyEvaluationSubjectUiModel(
        subjectName: s.subject,
        attendance: evaluation.attendance,
        participation: evaluation.participation,
        homework: evaluation.assignments,
        notes: evaluation.notes,
      ),
    ],
  );
}
