import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_filters.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_result.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_week_selector.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/gulf_schedule_grid_adapter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentGulfScheduleBody extends StatelessWidget {
  const ParentGulfScheduleBody({
    super.key,
    required this.childSelector,
    required this.onWeekChanged,
  });

  final Widget childSelector;
  final void Function(int, String) onWeekChanged;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ParentGulfScheduleCubit, ParentGulfScheduleState>(
        builder: (context, state) {
          final cubit = context.read<ParentGulfScheduleCubit>();
          return Column(
            children: [
              ParentScheduleFilters(
                childSelector: childSelector,
                weekSelector: ParentScheduleWeekSelector(
                  selectedWeek: state.selectedWeek,
                  maxWeek: state.maxWeek,
                  loading: state.status == ParentGulfScheduleStatus.loading,
                  onChanged: (value) {
                    final start = cubit.weekStartFor(value);
                    if (start != null) onWeekChanged(value, start);
                    cubit.selectWeek(value);
                  },
                ),
              ),
              Expanded(
                child: ParentScheduleResult(
                  initialLoading:
                      state.status == ParentGulfScheduleStatus.initial ||
                      (state.status == ParentGulfScheduleStatus.loading &&
                          state.currentWeek == null),
                  loading: state.status == ParentGulfScheduleStatus.loading,
                  error: state.status == ParentGulfScheduleStatus.failure
                      ? state.error
                      : null,
                  onRetry: cubit.load,
                  data: adaptGulfStudentSchedule(state.classrooms),
                  emptyMessage: S.of(context).noScheduleForWeek,
                ),
              ),
            ],
          );
        },
      );
}
