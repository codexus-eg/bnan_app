import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_assignment_error_message.dart';
import 'create_assignment_fields.dart';

class CreateAssignmentForm extends StatelessWidget {
  const CreateAssignmentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateAssignmentCubit>();

    return BlocConsumer<CreateAssignmentCubit, CreateAssignmentState>(
      listener: (context, state) {
        if (state is CreateAssignmentSuccess) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        final classroomState = context.watch<GetTeacherClassroomsCubit>().state;
        final subjectState = context
            .watch<GetTeacherAssignedSubjectsCubit>()
            .state;
        final hasUnavailableOptions =
            classroomState is GetTeacherClassroomsSuccess &&
                classroomState.classrooms.classrooms.isEmpty ||
            cubit.selectedClassroomId != null &&
                subjectState is GetTeacherAssignedSubjectsSuccess &&
                subjectState.response.data.subjects.isEmpty;

        return Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDialogHeader(title: S.of(context).createNewAssignment),
                  const SizedBox(height: 16),
                  const CreateAssignmentFields(),
                  const SizedBox(height: 16),
                  if (cubit.validationMessage != null &&
                      !hasUnavailableOptions) ...[
                    Text(
                      cubit.validationMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (state is CreateAssignmentFailure) ...[
                    CreateAssignmentErrorMessage(message: state.errorMessage),
                    const SizedBox(height: 8),
                  ],
                  CustomAppButton(
                    text: S.of(context).createAssignment,
                    isLoading: state is CreateAssignmentLoading,
                    onPressed: state is CreateAssignmentLoading
                        ? null
                        : cubit.createAssignment,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
