import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/delete_assignment/teacher_assignment_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentListBlocBuilder extends StatelessWidget {
  const TeacherAssignmentListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTeacherAssignmentsCubit, GetTeacherAssignmentsState>(
      builder: (context, state) {
        final isLoading =
            state is GetTeacherAssignmentsLoading ||
            state is GetTeacherAssignmentsInitial;
        final List<AssignmentModel> assignments =
            state is GetTeacherAssignmentsSuccess
            ? state.assignments.assignments
            : AssignmentModel.placeholderList();

        if (state is GetTeacherAssignmentsFailure) {
          return Center(child: Text(state.errorMessage));
        }
        if (!isLoading && assignments.isEmpty) {
          return const NoDataWidget();
        }
        final reversedAssignments = assignments.reversed.toList();

        return AppSkeletonizer(
          isLoading: isLoading,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: reversedAssignments.length,
            itemBuilder: (context, index) {
              return TeacherAssignmentDismissibleCard(
                assignment: reversedAssignments[index],
              );
            },
          ),
        );
      },
    );
  }
}
