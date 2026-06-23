import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/student_auth/data/models/grade_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_grades_subjects_data/teacher_grades_options_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherGradesOptionsList extends StatelessWidget {
  const TeacherGradesOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, teacherState) {
        final teacherCubit = TeacherRegistrationCubit.get(context);

        return BlocBuilder<GetGradesCubit, GetGradesState>(
          builder: (context, state) {
            final isLoading = state is GetGradesLoading;

            if (state is GetGradesFailure) {
              return Text(state.errorMessage);
            }

            final grades = state is GetGradesSuccess
                ? state.grades
                : GradeModel.placeholderList();

            return AppSkeletonizer(
              isLoading: isLoading,
              child: TeacherGradesOptionsListView(
                grades: grades,
                teacherCubit: teacherCubit,
                onGradeTap: (grade) {
                  teacherCubit.toggleTeachingGrade(gradeId: grade.id);

                },
              ),
            );
          },
        );
      },
    );
  }
}