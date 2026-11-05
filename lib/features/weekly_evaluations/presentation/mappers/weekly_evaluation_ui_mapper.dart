import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/evaluation_value_ui_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:flutter/widgets.dart';

WeeklyEvaluationUiModel mapWeeklyEvaluationToUi(
  BuildContext context,
  WeeklyEvaluationStudentModel student, {
  required String classroomName,
  required int week,
  required String title,
  required int index,
}) {
  return WeeklyEvaluationUiModel(
    id: '${student.id}-$week-$index',
    title: title,
    studentName: student.fullName,
    classroomName: classroomName,
    subjects: student.subjects.map((subject) {
      final value = subject.evaluation;
      final isEvaluated = subject.isEvaluated;
      return WeeklyEvaluationSubjectUiModel(
        id: subject.id,
        subjectName: subject.name,
        attendance: isEvaluated
            ? formatAttendanceWithCount(
                context: context,
                attendanceStatus: value!.attendance,
                attended: value.attendanceAttended,
                total: value.attendanceTotal,
              )
            : '-',
        participation: isEvaluated
            ? evaluationValueLabel(context, value!.participation)
            : '',
        homework: isEvaluated
            ? evaluationValueLabel(context, value!.homework)
            : '',
        behavior: isEvaluated
            ? evaluationValueLabel(context, value!.behavior)
            : '',
        notes: isEvaluated ? value!.notes : '',
        isEvaluated: isEvaluated,
      );
    }).toList(),
  );
}
