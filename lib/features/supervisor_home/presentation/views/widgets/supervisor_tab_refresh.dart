import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorTabRefresh extends StatefulWidget {
  const SupervisorTabRefresh({
    required this.route,
    required this.child,
    super.key,
  });

  final String route;
  final Widget child;

  @override
  State<SupervisorTabRefresh> createState() => SupervisorTabRefreshState();
}

class SupervisorTabRefreshState extends State<SupervisorTabRefresh> {
  Future<void> refresh() async {
    switch (widget.route) {
      case Routes.weeklyEvaluations:
        final evaluations = context.read<WeeklyEvaluationsCubit>();
        final classrooms = context.read<GetSupervisorClassroomsCubit>();
        await evaluations.initialize('supervisor');
        await Future.wait([
          classrooms.getMyClassrooms(),
          if (evaluations.selectedClassroom != null) evaluations.retry(),
        ]);
      case Routes.groups:
        await context.read<GetChatRoomsCubit>().getChatRooms();
      case Routes.certificatesManagement:
        await Future.wait([
          context.read<GetMonthlyCertificatesCubit>().getMonthlyCertificates(),
          context.read<GetSupervisorClassroomsCubit>().getMyClassrooms(),
        ]);
      case Routes.attendance:
        await context.read<AttendanceCubit>().initialize(UserRole.supervisor);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
