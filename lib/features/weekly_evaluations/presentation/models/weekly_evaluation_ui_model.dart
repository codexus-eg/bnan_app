import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';

class WeeklyEvaluationUiModel {
  const WeeklyEvaluationUiModel({
    required this.id,
    required this.title,
    required this.subjects,
    this.studentName,
    this.classroomName,
  });

  final String id;
  final String title;
  final String? studentName;
  final String? classroomName;
  final List<WeeklyEvaluationSubjectUiModel> subjects;
}
