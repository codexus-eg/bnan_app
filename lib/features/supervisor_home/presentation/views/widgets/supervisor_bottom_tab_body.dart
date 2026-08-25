import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/attendance/presentation/views/attendance_view.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_certificates_tab.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_tab_refresh.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/weekly_evaluations_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildSupervisorBottomTab(
  String route, {
  GlobalKey<SupervisorTabRefreshState>? refreshKey,
}) => switch (route) {
  Routes.weeklyEvaluations => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<WeeklyEvaluationsCubit>()),
      BlocProvider(create: (_) => getIt<GetSupervisorClassroomsCubit>()),
    ],
    child: SupervisorTabRefresh(
      key: refreshKey,
      route: route,
      child: const WeeklyEvaluationsView(showBackButton: false),
    ),
  ),
  Routes.groups => SupervisorTabRefresh(
    key: refreshKey,
    route: route,
    child: const GroupsView(showBackButton: false),
  ),
  Routes.certificatesManagement => SupervisorCertificatesTab(
    refreshKey: refreshKey,
  ),
  Routes.attendance => BlocProvider(
    create: (_) => getIt<AttendanceCubit>(),
    child: SupervisorTabRefresh(
      key: refreshKey,
      route: route,
      child: const AttendanceView(showBackButton: false),
    ),
  ),
  _ => const SizedBox.shrink(),
};
