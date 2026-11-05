import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/weekly_ideal_student_view.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/ideal_teacher_view.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/lessons_management_view.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/supervisor_plans_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildSupervisorDrawerRoot(String route) => switch (route) {
  Routes.plans => const SupervisorPlansRoot(),
  Routes.weeklyIdealStudents => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<IdealStudentCubit>()),
      BlocProvider(
        create: (_) => getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
      ),
    ],
    child: const WeeklyIdealStudentView(showBackButton: false),
  ),
  Routes.idealTeacher => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<SupervisorIdealTeacherCubit>()),
      BlocProvider(
        create: (_) => getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
      ),
    ],
    child: const IdealTeacherView(showBackButton: false),
  ),
  Routes.lessonsManagement => const LessonsManagementView(
    showBackButton: false,
  ),
  _ => const SizedBox.shrink(),
};
