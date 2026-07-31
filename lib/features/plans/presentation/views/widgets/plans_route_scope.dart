import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/plans/presentation/views/plans_view.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansRouteScope extends StatelessWidget {
  const PlansRouteScope({super.key});

  @override
  Widget build(BuildContext context) {
    final role = SessionManager.instance.userRole?.trim().toLowerCase();
    final policy = PlansAccessPolicy.fromRole(role);
    final plans = MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<GetWeeklyPlansCubit>()),
        BlocProvider(create: (_) => getIt<GetElapsedWeeksCubit>()),
        if (policy.showManagementActions) ...[
          BlocProvider(create: (_) => getIt<GetTermPlansCubit>()),
          BlocProvider(create: (_) => getIt<PlansActionsCubit>()),
          BlocProvider(create: (_) => getIt<GetClassroomSubjectsCubit>()),
          BlocProvider(create: (_) => getIt<GetTeacherAssignedSubjectsCubit>()),
          BlocProvider(create: (_) => getIt<ClassroomDetailsCubit>()),
        ],
      ],
      child: const PlansView(),
    );
    return switch (role) {
      'teacher' => BlocProvider(
        create: (_) => getIt<GetTeacherClassroomsCubit>()..getMyClassrooms(),
        child: plans,
      ),
      'student' => BlocProvider(
        create: (_) => getIt<GetMyEnrollmentsCubit>()..getMyEnrollments(),
        child: plans,
      ),
      'supervisor' => BlocProvider(
        create: (_) => getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
        child: plans,
      ),
      'admin' => BlocProvider(
        create: (_) => getIt<ClassroomsCubit>()..getClassrooms(),
        child: plans,
      ),
      _ => plans,
    };
  }
}
