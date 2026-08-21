import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyClassroomFilter extends StatelessWidget {
  const ReadOnlyClassroomFilter({super.key, required this.state});
  final ReadOnlyWeeklyEvaluationsState state;

  static Widget? fromState(ReadOnlyWeeklyEvaluationsState state) =>
      state.role == null ? null : ReadOnlyClassroomFilter(state: state);

  @override
  Widget build(BuildContext context) {
    final items = state.classrooms.isEmpty
        ? null
        : state.classrooms.map((item) => item.id).toList(growable: false);
    return CustomDropdown(
      key: const Key('readOnlyClassroomDropdown'),
      label: S.of(context).classRoom,
      value: state.selectedClassroomId,
      items: items,
      itemsLabels: {for (final item in state.classrooms) item.id: item.name},
      onChanged: (id) => id == null
          ? null
          : context.read<ReadOnlyWeeklyEvaluationsCubit>().selectClassroom(id),
      useDefaultIcon: true,
    );
  }
}
