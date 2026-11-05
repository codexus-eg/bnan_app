import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/teacher_subject_mock_data.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignments_cubit/teacher_subject_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_card.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_assignment_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSubjectAssignmentList extends StatelessWidget {
  const TeacherSubjectAssignmentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      TeacherSubjectAssignmentsCubit,
      TeacherSubjectAssignmentsState
    >(
      builder: (context, state) {
        if (state is GetTeachingAssignmentsEmpty) {
          return const NoDataWidget();
        }

        if (state is GetTeachingAssignmentsFailure) {
          return Center(child: Text(state.message));
        }

        final isLoading = state is GetTeachingAssignmentsLoading;

        final items = state is GetTeachingAssignmentsSuccess
            ? state.assignments
                  .map(TeacherSubjectAssignmentCardItem.fromApiItem)
                  .toList()
            : teacherSubjectMockData;

        return AppSkeletonizer(
          isLoading: isLoading,
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return TeacherAssignmentCard(item: items[index]);
            },
          ),
        );
      },
    );
  }
}
