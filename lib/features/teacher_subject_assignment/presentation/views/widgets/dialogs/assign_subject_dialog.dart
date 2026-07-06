import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
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
        if (state is BulkAssignTeachingAssignmentsSuccess) {
          Navigator.pop(context, true);
        }
        if (state is BulkAssignTeachingAssignmentsFailure) {
          setState(() => validationMessage = state.message);
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
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      validationMessage!,
                      style: StylesManager.styleRegular12(
                        context,
                      ).copyWith(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: s.save,
                    isLoading: state is BulkAssignTeachingAssignmentsLoading,
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

    if (!selection.isComplete(requireClassroom: true)) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

  context.read<TeacherSubjectAssignmentActionsCubit>().assignSubjectToTeacher(
      teacherId: widget.teacherId,
      curriculumId: selection.curriculumId!,
      assignment: TeachingAssignmentRequestModel(
        classroomId: selection.classroomId!,
        subjects: [selection.subjectId!],
      ),
    );
  }

  TextStyle getStyle(context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.greyA8AF);
  }
}
