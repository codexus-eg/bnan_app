import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignStudentButton extends StatelessWidget {
  const AssignStudentButton({
    super.key,
    required this.student,
    required this.classroom,
  });

  final UnassignedStudentModel? student;
  final AvailableClassroomModel? classroom;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignStudentCubit, AssignStudentState>(
      builder: (context, state) {
        final isLoading = state is AssignStudentLoading;
        final canSubmit = student != null && classroom != null;

        return CustomAppButton(
          text: S.of(context).save,
          isLoading: isLoading,
          onPressed: canSubmit
              ? () => _assignStudent(context)
              : null,
        );
      },
    );
  }

  void _assignStudent(BuildContext context) {
    context.read<AssignStudentCubit>().assignStudent(
      studentId: student!.id,
      classroomId: classroom!.id,
    );
  }
}