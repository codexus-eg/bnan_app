import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';

class EvaluationEditorContext {
  const EvaluationEditorContext({
    required this.studentId,
    required this.studentName,
    required this.classroomId,
    required this.classroomName,
    required this.week,
    required this.subject,
  });

  final String studentId, studentName, classroomId, classroomName;
  final int week;
  final EvaluationSubjectModel subject;
}
