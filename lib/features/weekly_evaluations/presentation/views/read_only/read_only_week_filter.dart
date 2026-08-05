import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyWeekFilter extends StatelessWidget {
  const ReadOnlyWeekFilter({
    super.key,
    required this.selectedWeek,
    required this.maxAvailableWeek,
  });
  final int selectedWeek, maxAvailableWeek;

  static Widget? fromState(ReadOnlyWeeklyEvaluationsState state) =>
      state.selectedWeek == null || state.maxAvailableWeek == null
      ? null
      : ReadOnlyWeekFilter(
          selectedWeek: state.selectedWeek!,
          maxAvailableWeek: state.maxAvailableWeek!,
        );

  @override
  Widget build(BuildContext context) {
    final items = [
      for (var value = 1; value <= maxAvailableWeek; value++) '$value',
    ];
    return CustomDropdown(
      key: const Key('readOnlyWeekDropdown'),
      label: S.of(context).week,
      value: '$selectedWeek',
      items: items,
      itemsLabels: {
        for (final item in items) item: S.of(context).weekNumber(item),
      },
      onChanged: (value) {
        final selected = int.tryParse(value ?? '');
        if (selected != null) {
          context.read<ReadOnlyWeeklyEvaluationsCubit>().selectWeek(selected);
        }
      },
      useDefaultIcon: true,
    );
  }
}
