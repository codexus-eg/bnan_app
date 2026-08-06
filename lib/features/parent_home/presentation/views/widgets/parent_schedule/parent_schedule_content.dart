import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleContent extends StatelessWidget {
  const ParentScheduleContent({super.key, required this.child});

  final ParentChildModel child;

  @override
  Widget build(BuildContext context) {
    final studentId = child.id.trim();
    if (studentId.isEmpty) return const NoDataWidget();
    return KeyedSubtree(
      key: ValueKey('$studentId:${child.registrationMode}'),
      child: switch (child.registrationMode) {
        RegistrationMode.egyptian => BlocProvider(
          create: (_) => GetEgyptianSchedulesCubit(
            getIt<TableManagementRepo>(),
            studentId: studentId,
          )..getMyEgyptianSchedule(),
          child: const EgyptianSchedulesReadOnlyBody(),
        ),
        RegistrationMode.gulf => BlocProvider(
          create: (_) => GulfScheduleCubit(
            getIt<GulfScheduleRepo>(),
            canManage: false,
            studentId: studentId,
          )..load(),
          child: const LessonsManagementBody(readOnly: true),
        ),
        null => const NoDataWidget(),
      },
    );
  }
}
