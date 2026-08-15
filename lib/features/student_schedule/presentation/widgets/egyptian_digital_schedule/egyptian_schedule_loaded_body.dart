import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/egyptian_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_week_filter.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';

class EgyptianScheduleLoadedBody extends StatelessWidget {
  const EgyptianScheduleLoadedBody({
    super.key,
    required this.state,
    required this.forStudent,
  });
  final EgyptianScheduleState state;
  final bool forStudent;

  @override
  Widget build(BuildContext context) {
    if (state.selectedWeek == null || state.maxWeek == null) {
      return NoDataWidget(title: S.of(context).noScheduleForWeek);
    }
    final data = adaptEgyptianSchedule(
      state.week!,
      secondaryText: (lesson) =>
          forStudent ? lesson.teacherName ?? '' : lesson.classroomName,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
          child: EgyptianScheduleWeekFilter(state: state),
        ),
        Expanded(
          child: state.status == EgyptianScheduleStatus.failure
              ? TableSchedulesFailure(
                  message: state.error,
                  onRetry: () => context.read<EgyptianScheduleCubit>().load(
                    selectedWeek: state.selectedWeek,
                  ),
                )
              : DigitalScheduleContent(
                  data: data,
                  loading: state.status == EgyptianScheduleStatus.loading,
                  emptyMessage: S.of(context).noScheduleForWeek,
                ),
        ),
      ],
    );
  }
}
