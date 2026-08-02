import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';

class EvaluationDialogContext {
  const EvaluationDialogContext.add({
    required this.week,
    required this.classrooms,
  }) : editor = null,
       classroomId = '',
       classroomName = '';

  factory EvaluationDialogContext.edit(EvaluationEditorContext editor) =>
      EvaluationDialogContext._(
        editor: editor,
        classroomId: editor.classroomId,
        classroomName: editor.classroomName,
        week: editor.week,
        classrooms: const [],
      );

  const EvaluationDialogContext._({
    required this.editor,
    required this.classroomId,
    required this.classroomName,
    required this.week,
    required this.classrooms,
  });

  final EvaluationEditorContext? editor;
  final String classroomId, classroomName;
  final int week;
  final List<PlanClassroomOption> classrooms;
  bool get isEdit => editor != null;
}
