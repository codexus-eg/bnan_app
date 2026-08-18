import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_filters.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_result.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/gulf_schedule_grid_adapter.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentGulfScheduleBody extends StatelessWidget {
  const ParentGulfScheduleBody({super.key, required this.childSelector});

  final Widget childSelector;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ParentGulfScheduleCubit, ParentGulfScheduleState>(
        builder: (context, state) {
          final cubit = context.read<ParentGulfScheduleCubit>();
          return Column(
            children: [
              ParentScheduleFilters(childSelector: childSelector),
              Expanded(
                child: ParentScheduleResult(
                  initialLoading:
                      state.status == ParentGulfScheduleStatus.initial ||
                      state.status == ParentGulfScheduleStatus.loading,
                  loading: state.status == ParentGulfScheduleStatus.loading,
                  error: state.status == ParentGulfScheduleStatus.failure
                      ? state.error
                      : null,
                  onRetry: cubit.load,
                  data: adaptGulfStudentSchedule(state.classrooms),
                  emptyMessage: S.of(context).noSchedule,
                ),
              ),
            ],
          );
        },
      );
}
