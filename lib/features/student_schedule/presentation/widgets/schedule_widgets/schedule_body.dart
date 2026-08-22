import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_body.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/gulf_student_schedule_body.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
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
                      EgyptianScheduleCubit(getIt<TableManagementRepo>())
                        ..load(),
                  child: const EgyptianScheduleBody(forStudent: true),
                )
              : session.isGulfStudent
              ? BlocProvider(
                  create: (_) => GulfScheduleCubit(
                    getIt<GulfScheduleRepo>(),
                    canManage: false,
                  )..load(),
                  child: const GulfStudentScheduleBody(),
                )
              : const NoDataWidget(),
        ),
      ],
    );
  }
}
