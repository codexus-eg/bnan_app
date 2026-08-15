import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/gulf_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GulfStudentScheduleBody extends StatelessWidget {
  const GulfStudentScheduleBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GulfScheduleCubit, GulfScheduleState>(
        builder: (context, state) {
          if (state.status == GulfScheduleLoadStatus.initial ||
              state.status == GulfScheduleLoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == GulfScheduleLoadStatus.failure) {
            return TableSchedulesFailure(
              message: state.loadError ?? S.of(context).gulfScheduleLoadFailed,
              onRetry: context.read<GulfScheduleCubit>().load,
            );
          }
          return DigitalScheduleContent(
            data: adaptGulfStudentSchedule(state.classrooms),
            emptyMessage: S.of(context).noSchedule,
          );
        },
      );
}
