import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/plans/presentation/views/plans_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorPlansRoot extends StatelessWidget {
  const SupervisorPlansRoot({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<GetWeeklyPlansCubit>()),
      BlocProvider(create: (_) => getIt<GetElapsedWeeksCubit>()),
      BlocProvider(create: (_) => getIt<GetTermPlansCubit>()),
      BlocProvider(create: (_) => getIt<PlansActionsCubit>()),
      BlocProvider(create: (_) => getIt<GetClassroomSubjectsCubit>()),
      BlocProvider(create: (_) => getIt<GetTeacherAssignedSubjectsCubit>()),
      BlocProvider(create: (_) => getIt<ClassroomDetailsCubit>()),
      BlocProvider(
        create: (_) => getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
      ),
    ],
    child: const PlansView(showBackButton: false),
  );
}
