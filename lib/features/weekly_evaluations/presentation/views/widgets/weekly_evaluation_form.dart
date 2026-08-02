import 'package:bnan_app/core/helper/my_snack_bar.dart';
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
  late final TextEditingController _notesController;
  String? studentId, subjectId;
  String attendance = 'present';
  String participation = 'good', homework = 'good', behavior = 'good';

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    final editor = widget.data.editor;
    if (editor != null) {
      studentId = editor.studentId;
      subjectId = editor.subject.id;
      _fillFrom(editor.subject);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  WeeklyEvaluationStudentModel? get _student => widget.data.isEdit
      ? null
      : widget.data.students.where((item) => item.id == studentId).firstOrNull;

  List<EvaluationSubjectModel> get _subjects => widget.data.isEdit
      ? [widget.data.editor!.subject]
      : (_student?.subjects.where((item) => !item.isEvaluated).toList() ?? []);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<WeeklyEvaluationsCubit, WeeklyEvaluationsState>(
      listener: _listen,
      builder: (context, state) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: widget.title),
            const SizedBox(height: 16),
            EvaluationIdentityFields(
              data: widget.data,
              studentId: studentId,
              subjectId: subjectId,
              subjects: _subjects,
              onStudentChanged: _selectStudent,
              onSubjectChanged: _selectSubject,
            ),
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
            CustomAppButton(
              text: s.save,
              isLoading: state is EvaluationSaving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  void _selectStudent(String? value) => setState(() {
    studentId = value;
    subjectId = null;
  });

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
    if (state is EvaluationSaveFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }

  void _save() {
    final subject = _subjects.where((item) => item.id == subjectId).firstOrNull;
    if (studentId == null) {
      showCustomSnackBar(context, S.of(context).pleaseSelectStudent, false);
      return;
    }
    if (subject == null) {
      showCustomSnackBar(context, S.of(context).subjectRequired, false);
      return;
    }
    context.read<WeeklyEvaluationsCubit>().upsert(
      UpsertEvaluationRequestModel(
        student: studentId!,
        classroom: widget.data.classroomId,
        subject: subject.id,
        week: widget.data.week,
        attendance: attendance,
        participation: participation,
        homework: homework,
        behavior: behavior,
        notes: _notesController.text.trim(),
      ),
    );
  }
}
