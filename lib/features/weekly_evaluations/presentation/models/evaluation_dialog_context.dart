import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';

class EvaluationDialogContext {
  const EvaluationDialogContext.add({
    required this.students,
    required this.classroomId,
    required this.classroomName,
    required this.week,
  }) : editor = null;

  factory EvaluationDialogContext.edit(EvaluationEditorContext editor) =>
      EvaluationDialogContext._(
        editor: editor,
        classroomId: editor.classroomId,
        classroomName: editor.classroomName,
        week: editor.week,
      );

  const EvaluationDialogContext._({
    required this.editor,
    required this.classroomId,
    required this.classroomName,
    required this.week,
  }) : students = const [];

  final EvaluationEditorContext? editor;
  final List<WeeklyEvaluationStudentModel> students;
  final String classroomId, classroomName;
  final int week;
  bool get isEdit => editor != null;
}
