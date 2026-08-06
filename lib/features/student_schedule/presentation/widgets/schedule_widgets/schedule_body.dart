import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return Column(
      children: [
        CustomAppbar(
          headerText: S.of(context).studySchedule,
          iconNeeded: false,
        ),
        Expanded(
          child: session.isEgyptianStudent
              ? BlocProvider(
                  create: (_) =>
                      getIt<GetEgyptianSchedulesCubit>()
                        ..getMyEgyptianSchedule(),
                  child: const EgyptianSchedulesReadOnlyBody(),
                )
              : session.isGulfStudent
              ? BlocProvider(
                  create: (_) => GulfScheduleCubit(
                    getIt<GulfScheduleRepo>(),
                    canManage: false,
                  )..load(),
                  child: const LessonsManagementBody(readOnly: true),
                )
              : const NoDataWidget(),
        ),
      ],
    );
  }
}
