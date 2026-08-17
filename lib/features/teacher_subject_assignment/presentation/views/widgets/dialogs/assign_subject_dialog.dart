import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/teacher_assignment_dialog_error.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignSubjectDialog extends StatefulWidget {
  const AssignSubjectDialog({
    super.key,
    required this.teacherId,
    required this.teacherName,
  });

  final String teacherId;
  final String teacherName;

  @override
  State<AssignSubjectDialog> createState() => AssignSubjectDialogState();
}

class AssignSubjectDialogState extends State<AssignSubjectDialog> {
  final formKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  AcademicLookupSelection selection = const AcademicLookupSelection();
  String? validationMessage;

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<
      TeacherSubjectAssignmentActionsCubit,
      TeacherSubjectAssignmentActionsState
    >(
      listener: (context, state) {
        if (state is AssignTeacherSuccess) {
          Navigator.pop(context, state.response.message);
        }
        if (state is AssignTeacherFailure) {
          setState(() => validationMessage = state.errorMessage);
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
                  CustomDialogHeader(
                    title: s.assignTeacherInSubject(widget.teacherName),
                  ),
                  const SizedBox(height: 16),
                  AcademicLookupDropdowns(
                    showCurriculum: true,
                    showGrade: true,
                    showClassroom: true,
                    showSubject: true,
                    onSelectionChanged: (value) {
                      setState(() {
                        selection = value;
                        validationMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: s.hourlyRate,
                    controller: priceController,
                    labelColor: ColorManager.mainColor14,
                    keyboardType: TextInputType.number,
                    hintStyle: getStyle(context),
                    onChanged: (_) => setState(() => validationMessage = null),
                    validator: validatePrice,
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
                    TeacherAssignmentDialogError(message: validationMessage!),
                  ],
                  const SizedBox(height: 16),
                  BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
                    builder: (context, lookupState) {
                      final selectedSubjectId = lookupState.selectedSubject?.id;
                      final hasCurrentSubject =
                          selectedSubjectId != null &&
                          lookupState.subjects.any(
                            (subject) => subject.id == selectedSubjectId,
                          );
                      return CustomAppButton(
                        text: s.save,
                        isLoading: state is AssignTeacherLoading,
                        onPressed:
                            lookupState.grades.isEmpty ||
                                lookupState.classrooms.isEmpty ||
                                lookupState.isLoadingSubjects ||
                                !hasCurrentSubject ||
                                !hasValidPrice
                            ? null
                            : submit,
                      );
                    },
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

    final lookupState = context.read<AcademicLookupsCubit>().state;
    final subjectBelongsToCurrentClassroom =
        lookupState.selectedClassroom?.id == selection.classroomId &&
        lookupState.selectedSubject?.id == selection.subjectId &&
        lookupState.subjects.any(
          (subject) => subject.id == selection.subjectId,
        );
    if (!selection.isComplete(requireClassroom: true) ||
        !subjectBelongsToCurrentClassroom) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

    final price = num.parse(priceController.text.trim());
    setState(() => validationMessage = null);
    context.read<TeacherSubjectAssignmentActionsCubit>().assignTeacher(
      teacherId: widget.teacherId,
      curriculumId: selection.curriculumId!,
      gradeId: selection.gradeId!,
      classroomId: selection.classroomId!,
      subjectId: lookupState.selectedSubject!.subjectId,
      pricePerSession: price,
    );
  }

  bool get hasValidPrice {
    final price = num.tryParse(priceController.text.trim());
    return price != null && price > 0;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.hourlyRateRequired;
    }
    final price = num.tryParse(value.trim());
    if (price == null || price <= 0) return S.current.hourlyRateMustBeNumber;
    return null;
  }

  TextStyle getStyle(context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.greyA8AF);
  }
}
