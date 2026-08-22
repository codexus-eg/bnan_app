import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_body.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentEgyptianScheduleView extends StatelessWidget {
  const StudentEgyptianScheduleView({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) =>
            EgyptianScheduleCubit(getIt<TableManagementRepo>())..load(),
      ),
      BlocProvider(create: (_) => getIt<StartSessionCubit>()),
    ],
    child: Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).studySchedule),
      body: const EgyptianScheduleBody(forStudent: true),
    ),
  );
}
