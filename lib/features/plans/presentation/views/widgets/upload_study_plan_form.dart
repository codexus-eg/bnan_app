import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialog_error_message.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_fields.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_classroom_subjects/get_classroom_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadStudyPlanForm extends StatefulWidget {
  const UploadStudyPlanForm({
    super.key,
    required this.policy,
    required this.classrooms,
    this.initialClassroom,
    this.filePicker,
  });

  final PlansAccessPolicy policy;
  final List<PlanClassroomOption> classrooms;
  final PlanClassroomOption? initialClassroom;
  final PlansFilePicker? filePicker;

  @override
  State<UploadStudyPlanForm> createState() => _UploadStudyPlanFormState();
}

class _UploadStudyPlanFormState extends State<UploadStudyPlanForm> {
  final _formKey = GlobalKey<FormState>();
  PlanClassroomOption? _classroom;
  String? _subjectId;
  File? _file;
  String? _fileError;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialClassroom;
    _classroom = widget.classrooms.any((item) => item.id == initial?.id)
        ? initial
        : null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _subjects(context);
    final s = S.of(context);
    return BlocConsumer<PlansActionsCubit, PlansActionsState>(
      listenWhen: (_, state) => state is UploadTermPlanSuccess,
      listener: (context, state) {
        Navigator.of(context).pop(_classroom!.id);
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.uploadStudyPlan),
            const SizedBox(height: 16),
            UploadStudyPlanFields(
              classrooms: widget.classrooms,
              classroomId: _classroom?.id,
              subjectId: _subjectId,
              subjectHint: subjects.$1,
              subjects: subjects.$2,
              fileName: _fileName,
              fileError: _fileError,
              onClassroomChanged: _onClassroomChanged,
              onSubjectChanged: (value) => setState(() => _subjectId = value),
              onPickFile: _pickFile,
            ),
            if (state is UploadTermPlanFailure) ...[
              const SizedBox(height: 16),
              PlansDialogErrorMessage(message: state.message),
            ],
            const SizedBox(height: 16),
            CustomAppButton(
              text: s.uploadAction,
              isLoading: state is UploadTermPlanLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  (String, Map<String, String>) _subjects(BuildContext context) {
    final s = S.of(context);
    if (widget.policy.usesClassroomSubjectsInAddDialog) {
      final state = context.watch<GetClassroomSubjectsCubit>().state;
      if (state is GetClassroomSubjectsLoading) return (s.loading, const {});
      if (state is GetClassroomSubjectsFailure) {
        return (state.errorMessage, const {});
      }
      final items = state is GetClassroomSubjectsSuccess
          ? state.classroomSubjects.subjects
          : const [];
      return (s.selectSubject, {for (final item in items) item.id: item.name});
    }
    final state = context.watch<GetTeacherAssignedSubjectsCubit>().state;
    if (state is GetTeacherAssignedSubjectsLoading) {
      return (s.loading, const {});
    }
    if (state is GetTeacherAssignedSubjectsFailure) {
      return (state.errorMessage, const {});
    }
    final items = state is GetTeacherAssignedSubjectsSuccess
        ? state.response.data.subjects
        : const [];
    return (s.selectSubject, {for (final item in items) item.id: item.name});
  }

  String? get _fileName {
    final path = _file?.path;
    if (path == null || path.isEmpty) return null;
    return path.split(RegExp(r'[\\/]')).last;
  }

  void _onClassroomChanged(String? classroomId) {
    setState(() {
      _classroom = widget.classrooms
          .where((item) => item.id == classroomId)
          .firstOrNull;
      _subjectId = null;
    });
    _loadSubjects();
  }

  void _loadSubjects() {
    final classroomId = _classroom?.id;
    if (!mounted || classroomId == null) return;
    if (widget.policy.usesClassroomSubjectsInAddDialog) {
      context.read<GetClassroomSubjectsCubit>().getClassroomSubjects(
        classroomId: classroomId,
      );
      return;
    }
    context.read<GetTeacherAssignedSubjectsCubit>().getTeacherAssignedSubjects(
      classroomId: classroomId,
    );
  }

  Future<void> _pickFile() async {
    final file = await (widget.filePicker ?? _pickAnyFile)();
    if (file == null || !mounted) return;
    setState(() {
      _file = file;
      _fileError = null;
    });
  }

  Future<File?> _pickAnyFile() =>
      FilePickerHelper.pickFile(allowedExtensions: null);

  void _submit() {
    if (context.read<PlansActionsCubit>().state is UploadTermPlanLoading) {
      return;
    }
    final validFields = _formKey.currentState?.validate() ?? false;
    if (_file == null) {
      setState(() => _fileError = S.of(context).planFileRequired);
    }
    if (!validFields || _file == null) return;
    context.read<PlansActionsCubit>().uploadTermPlan(
      classroomId: _classroom!.id,
      subjectId: _subjectId!,
      attachmentPath: _file!.path,
    );
  }
}
