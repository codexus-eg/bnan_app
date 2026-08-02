import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/evaluation_dialog_error_message.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/evaluation_identity_fields.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/evaluation_score_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyEvaluationForm extends StatefulWidget {
  const WeeklyEvaluationForm({
    super.key,
    required this.title,
    required this.data,
  });
  final String title;
  final EvaluationDialogContext data;

  @override
  State<WeeklyEvaluationForm> createState() => _WeeklyEvaluationFormState();
}

class _WeeklyEvaluationFormState extends State<WeeklyEvaluationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late final TextEditingController _weekController;
  String? classroomId, studentId, subjectId;
  String? attendance, participation, homework, behavior;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _weekController = TextEditingController(text: '${widget.data.week}');
    final editor = widget.data.editor;
    if (editor == null) {
      attendance = 'present';
      participation = 'excellent';
      homework = 'excellent';
      behavior = 'excellent';
      context.read<WeeklyEvaluationsCubit>().clearFormOptions();
    } else {
      classroomId = editor.classroomId;
      studentId = editor.studentId;
      subjectId = editor.subject.id;
      _fillFrom(editor.subject);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _weekController.dispose();
    super.dispose();
  }

  List<WeeklyEvaluationStudentModel> get _students {
    if (widget.data.isEdit || classroomId == null) return const [];
    return context.read<WeeklyEvaluationsCubit>().formStudents;
  }

  List<EvaluationSubjectModel> get _subjects => widget.data.isEdit
      ? [widget.data.editor!.subject]
      : context.read<WeeklyEvaluationsCubit>().formSubjects;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<WeeklyEvaluationsCubit, WeeklyEvaluationsState>(
      listener: _listen,
      builder: (context, state) => SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(title: widget.title),
              const SizedBox(height: 16),
              EvaluationIdentityFields(
                data: widget.data,
                classroomId: classroomId,
                studentId: studentId,
                subjectId: subjectId,
                students: _students,
                subjects: _subjects,
                weekController: _weekController,
                emptySubjectsMessage:
                    context.read<WeeklyEvaluationsCubit>().isTeacher
                    ? s.noSubjectsAvailableForTeacherStudent
                    : s.noSubjectsForStudent,
                showAvailabilityMessages:
                    state is EvaluationStudentsLoaded ||
                    state is EvaluationSubjectsLoaded,
                onClassroomChanged: _selectClassroom,
                onStudentChanged: _selectStudent,
                onSubjectChanged: _selectSubject,
                onWeekChanged: (_) => setState(() {}),
              ),
              if (state is EvaluationOptionsFailure) ...[
                const SizedBox(height: 12),
                EvaluationDialogErrorMessage(message: state.message),
              ],
              const SizedBox(height: 16),
              EvaluationScoreFields(
                attendance: attendance,
                participation: participation,
                homework: homework,
                behavior: behavior,
                onAttendanceChanged: (value) =>
                    setState(() => attendance = value),
                onParticipationChanged: (value) =>
                    setState(() => participation = value),
                onHomeworkChanged: (value) => setState(() => homework = value),
                onBehaviorChanged: (value) => setState(() => behavior = value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: s.notesText,
                controller: _notesController,
                maxLine: 3,
                backgroundColor: ColorManager.white,
              ),
              const SizedBox(height: 16),
              if (state is EvaluationSaveFailure) ...[
                EvaluationDialogErrorMessage(message: state.message),
                const SizedBox(height: 16),
              ],
              CustomAppButton(
                text: s.save,
                isLoading: state is EvaluationSaving,
                onPressed: state is EvaluationSaving || !_canSave
                    ? null
                    : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canSave =>
      classroomId != null &&
      studentId != null &&
      subjectId != null &&
      attendance != null &&
      participation != null &&
      homework != null &&
      behavior != null &&
      (int.tryParse(_weekController.text) ?? 0) > 0;

  void _selectClassroom(String? value) {
    setState(() {
      classroomId = value;
      studentId = null;
      subjectId = null;
    });
    if (value != null) {
      context.read<WeeklyEvaluationsCubit>().loadFormStudents(value);
    }
  }

  void _selectStudent(String? value) {
    setState(() {
      studentId = value;
      subjectId = null;
    });
    final classroom = classroomId;
    if (classroom != null && value != null) {
      context.read<WeeklyEvaluationsCubit>().loadFormSubjects(
        classroomId: classroom,
        studentId: value,
      );
    }
  }

  void _selectSubject(String? value) => setState(() => subjectId = value);

  void _fillFrom(EvaluationSubjectModel subject) {
    final value = subject.evaluation;
    if (value == null) return;
    if (value.attendance.isNotEmpty) attendance = value.attendance;
    if (value.participation.isNotEmpty) participation = value.participation;
    if (value.homework.isNotEmpty) homework = value.homework;
    if (value.behavior.isNotEmpty) behavior = value.behavior;
    _notesController.text = value.notes;
  }

  void _listen(BuildContext context, WeeklyEvaluationsState state) {
    if (state is EvaluationSaved) Navigator.of(context).pop();
  }

  void _save() {
    if (!_canSave || !(_formKey.currentState?.validate() ?? false)) return;
    final subject = _subjects.where((item) => item.id == subjectId).firstOrNull;
    if (subject == null) return;
    context.read<WeeklyEvaluationsCubit>().upsert(
      UpsertEvaluationRequestModel(
        student: studentId!,
        classroom: classroomId!,
        subject: subject.id,
        week: int.parse(_weekController.text),
        attendance: attendance!,
        participation: participation!,
        homework: homework!,
        behavior: behavior!,
        notes: _notesController.text.trim(),
      ),
    );
  }
}
