import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_application_mock_data.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/pending_teacher_requests_cubit/pending_teacher_requests_cubit.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/pending_teacher_requests_cubit/pending_teacher_requests_state.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_applications_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherApplicationBody extends StatelessWidget {
  const TeacherApplicationBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      PendingTeacherRequestsCubit,
      PendingTeacherRequestsState
    >(
      builder: (context, state) {
        final isLoading = state is PendingTeacherRequestsLoading;
        final teachers = state is PendingTeacherRequestsSuccess
            ? state.response.data.reversed.toList()
            : teacherApplicationsMockData;

        if (state is PendingTeacherRequestsFailure) {
          return Center(child: Text(state.message));
        }

        if (!isLoading && teachers.isEmpty) {
          return const NoDataWidget();
        }

        return TeacherApplicationsList(
          teachers: teachers,
          isLoading: isLoading,
        );
      },
    );
  }
}
