import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';

class EvaluationDialogContext {
  const EvaluationDialogContext.add({
    required this.week,
    required this.classrooms,
  }) : editor = null,
       editSubjects = const [],
       classroomId = '',
       classroomName = '';

  factory EvaluationDialogContext.edit(
    EvaluationEditorContext editor, {
    List<EvaluationSubjectModel> subjects = const [],
  }) => EvaluationDialogContext._(
    editor: editor,
    editSubjects: subjects,
    classroomId: editor.classroomId,
    classroomName: editor.classroomName,
    week: editor.week,
    classrooms: const [],
  );

  const EvaluationDialogContext._({
    required this.editor,
    required this.editSubjects,
    required this.classroomId,
    required this.classroomName,
    required this.week,
    required this.classrooms,
  });

  final EvaluationEditorContext? editor;
  final List<EvaluationSubjectModel> editSubjects;
  final String classroomId, classroomName;
  final int week;
  final List<PlanClassroomOption> classrooms;
  bool get isEdit => editor != null;
}
