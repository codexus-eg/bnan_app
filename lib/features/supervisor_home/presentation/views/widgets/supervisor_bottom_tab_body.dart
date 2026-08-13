import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/attendance/presentation/views/attendance_view.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_certificates_tab.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/weekly_evaluations_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildSupervisorBottomTab(String route) => switch (route) {
  Routes.weeklyEvaluations => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) =>
            getIt<WeeklyEvaluationsCubit>()..initialize('supervisor'),
      ),
      BlocProvider(
        create: (_) => getIt<GetSupervisorClassroomsCubit>()..getMyClassrooms(),
      ),
    ],
    child: const WeeklyEvaluationsView(showBackButton: false),
  ),
  Routes.groups => BlocProvider(
    create: (_) => getIt<GetChatRoomsCubit>()..getChatRooms(),
    child: const GroupsView(showBackButton: false),
  ),
  Routes.certificatesManagement => const SupervisorCertificatesTab(),
  Routes.attendance => BlocProvider(
    create: (_) => getIt<AttendanceCubit>()..initialize(UserRole.supervisor),
    child: const AttendanceView(showBackButton: false),
  ),
  _ => const SizedBox.shrink(),
};
