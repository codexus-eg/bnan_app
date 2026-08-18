import 'package:bnan_app/features/parent_home/presentation/manager/parent_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_filters.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_result.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/egyptian_schedule_grid_adapter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentEgyptianScheduleBody extends StatelessWidget {
  const ParentEgyptianScheduleBody({super.key, required this.childSelector});

  final Widget childSelector;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ParentEgyptianScheduleCubit, EgyptianScheduleState>(
        builder: (context, state) {
          final cubit = context.read<ParentEgyptianScheduleCubit>();
          final week = state.week;
          final data = week == null
              ? const DigitalScheduleGridData(days: [], times: [], cells: {})
              : adaptEgyptianSchedule(
                  week,
                  secondaryText: (lesson) => lesson.teacherName ?? '',
                );
          return Column(
            children: [
              ParentScheduleFilters(childSelector: childSelector),
              Expanded(
                child: ParentScheduleResult(
                  initialLoading:
                      week == null &&
                      state.status != EgyptianScheduleStatus.failure,
                  loading: state.status == EgyptianScheduleStatus.loading,
                  error: state.status == EgyptianScheduleStatus.failure
                      ? state.error
                      : null,
                  onRetry: cubit.load,
                  data: data,
                  emptyMessage: S.of(context).noSchedule,
                ),
              ),
            ],
          );
        },
      );
}
