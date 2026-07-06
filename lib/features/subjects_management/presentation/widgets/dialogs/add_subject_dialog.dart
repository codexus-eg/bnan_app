import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_state.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_field.dart';
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
  AcademicLookupSelection selection = const AcademicLookupSelection();
  String? validationMessage;

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
        if (state is AddSubjectSuccess) {
          Navigator.pop(context, true);
        }
        if (state is AddSubjectFailure) {
          showCustomSnackBar(context, state.message, false);
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
                    onChanged: (_) => setState(() => validationMessage = null),
                  ),
                  const SizedBox(height: 16),
                  AcademicLookupDropdowns(
                    showCurriculum: true,
                    showGrade: false,
                    showClassroom: false,
                    showSubject: false,
                    onSelectionChanged: (value) {
                      setState(() {
                        selection = value;
                        validationMessage = null;
                      });
                    },
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      validationMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: s.save,
                    isLoading: state is AddSubjectLoading,
                    onPressed: submit,
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

    final curriculumId = selection.curriculumId;
    // final gradeId = selection.gradeId;
    if (curriculumId == null ) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

    context.read<SubjectActionsCubit>().addSubject(
      name: nameController.text.trim(),
      curriculumId: curriculumId,
      // gradeId: gradeId,
    );
  }
}
