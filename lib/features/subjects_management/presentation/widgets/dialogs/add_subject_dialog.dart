import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_state.dart';
import 'package:bnan_app/features/subjects_management/presentation/policies/subject_action_error.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/grade_multi_selection.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_field.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSubjectDialog extends StatefulWidget {
  const AddSubjectDialog({super.key});

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  Set<String> selectedGradeIds = {};
  String? validationMessage;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<AcademicLookupsCubit, AcademicLookupsState>(
      listenWhen: (previous, current) =>
          previous.selectedCurriculum?.id != current.selectedCurriculum?.id,
      listener: (_, __) => setState(() {
        selectedGradeIds = {};
        validationMessage = null;
      }),
      child: BlocConsumer<SubjectActionsCubit, SubjectActionsState>(
        listener: (context, state) {
          if (state is AddSubjectSuccess) {
            Navigator.pop(context, true);
          }
          if (state is AddSubjectFailure) {
            setState(() {
              validationMessage = subjectActionError(
                s,
                state.code,
                state.message,
              );
            });
          }
        },
        builder: (context, state) {
          return CustomAppDialog(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDialogHeader(title: s.addNewSubject),
                    const SizedBox(height: 16),
                    SubjectDialogField(
                      label: s.subjectName,
                      controller: nameController,
                      validator: (value) => value?.trim().isEmpty ?? true
                          ? s.fillAllRequiredFields
                          : null,
                      onChanged: (_) =>
                          setState(() => validationMessage = null),
                    ),
                    const SizedBox(height: 16),
                    AcademicLookupDropdowns(
                      showCurriculum: true,
                      showGrade: false,
                      showClassroom: false,
                      showSubject: false,
                      gradeHint: s.chooseGrade,
                      onSelectionChanged: (_) {},
                    ),
                    const SizedBox(height: 16),
                    GradeMultiSelection(
                      selectedIds: selectedGradeIds,
                      onChanged: (value) => setState(() {
                        selectedGradeIds = value;
                        validationMessage = null;
                      }),
                    ),
                    if (validationMessage != null) ...[
                      const SizedBox(height: 16),
                      SubjectDialogError(message: validationMessage!),
                    ],
                    const SizedBox(height: 16),
                    CustomAppButton(
                      text: s.save,
                      isLoading: state is AddSubjectLoading,
                      onPressed: _canSubmit(state) ? submit : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final curriculumId = context
        .read<AcademicLookupsCubit>()
        .state
        .selectedCurriculum
        ?.id;
    if (curriculumId == null) {
      setState(() => validationMessage = S.of(context).fillAllRequiredFields);
      return;
    }
    if (selectedGradeIds.isEmpty) {
      setState(() => validationMessage = S.of(context).gradeRequired);
      return;
    }

    setState(() => validationMessage = null);
    context.read<SubjectActionsCubit>().addSubject(
      name: nameController.text.trim(),
      curriculumId: curriculumId,
      gradeIds: selectedGradeIds.toList(growable: false),
    );
  }

  bool _canSubmit(SubjectActionsState state) {
    final lookups = context.read<AcademicLookupsCubit>().state;
    return nameController.text.trim().isNotEmpty &&
        lookups.selectedCurriculum != null &&
        selectedGradeIds.isNotEmpty &&
        !lookups.isLoadingGrades &&
        lookups.errorMessage == null &&
        lookups.grades.isNotEmpty &&
        state is! AddSubjectLoading;
  }
}
