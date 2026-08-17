import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_state.dart';
import 'package:bnan_app/features/subjects_management/presentation/policies/subject_action_error.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/grade_multi_selection.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSubjectDialog extends StatefulWidget {
  const EditSubjectDialog({super.key, required this.subject});

  final SubjectModel subject;

  @override
  State<EditSubjectDialog> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends State<EditSubjectDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late Set<String> selectedGradeIds;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.subject.name);
    selectedGradeIds = widget.subject.grades
        .map((item) => item.id)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadGrades());
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<SubjectActionsCubit, SubjectActionsState>(
      listener: (context, state) {
        if (state is UpdateSubjectSuccess) Navigator.pop(context, true);
        if (state is UpdateSubjectFailure) {
          showCustomSnackBar(
            context,
            subjectActionError(s, state.code, state.message),
            false,
          );
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDialogHeader(title: s.editSubject),
                  const SizedBox(height: 16),
                  SubjectDialogField(
                    label: s.subjectName,
                    controller: nameController,
                    validator: (value) => value?.trim().isEmpty ?? true
                        ? s.fillAllRequiredFields
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  ClassMetaRow(
                    label: s.curriculum,
                    value: widget.subject.curriculum?.name ?? '-',
                  ),
                  const SizedBox(height: 16),
                  GradeMultiSelection(
                    selectedIds: selectedGradeIds,
                    onChanged: (value) => setState(() {
                      selectedGradeIds = value;
                    }),
                  ),
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: s.save,
                    isLoading: state is UpdateSubjectLoading,
                    onPressed: _canSubmit(state) ? submit : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    context.read<SubjectActionsCubit>().updateSubject(
      subjectId: widget.subject.id,
      name: nameController.text.trim(),
      gradeIds: selectedGradeIds.toList(growable: false),
    );
  }

  void _loadGrades() {
    if (!mounted) return;
    final curriculum = widget.subject.curriculum;
    if (curriculum == null || curriculum.id.isEmpty) return;
    context.read<AcademicLookupsCubit>().selectCurriculum(
      AcademicCurriculumModel(id: curriculum.id, name: curriculum.name),
    );
  }

  bool _canSubmit(SubjectActionsState state) =>
      nameController.text.trim().isNotEmpty &&
      selectedGradeIds.isNotEmpty &&
      state is! UpdateSubjectLoading;
}
