import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_loaded_body.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianScheduleBody extends StatelessWidget {
  const EgyptianScheduleBody({super.key, required this.forStudent});
  final bool forStudent;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EgyptianScheduleCubit, EgyptianScheduleState>(
        builder: (context, state) {
          if (state.week == null) {
            if (state.status == EgyptianScheduleStatus.failure) {
              return TableSchedulesFailure(
                message: state.error,
                onRetry: context.read<EgyptianScheduleCubit>().load,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
          return BlocProvider(
            create: (_) => getIt<StartSessionCubit>(),
            child: EgyptianScheduleLoadedBody(
              state: state,
              forStudent: forStudent,
            ),
          );
        },
      );
}
