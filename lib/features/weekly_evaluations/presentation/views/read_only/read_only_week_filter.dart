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
  final int? selectedWeek, maxAvailableWeek;

  static Widget? fromState(ReadOnlyWeeklyEvaluationsState state) =>
      state.role == null
      ? null
      : ReadOnlyWeekFilter(
          selectedWeek: state.selectedWeek,
          maxAvailableWeek: state.maxAvailableWeek,
        );

  @override
  Widget build(BuildContext context) {
    final maxWeek = maxAvailableWeek;
    final items = maxWeek == null
        ? null
        : [for (var value = 1; value <= maxWeek; value++) '$value'];
    return CustomDropdown(
      key: const Key('readOnlyWeekDropdown'),
      label: S.of(context).week,
      value: selectedWeek?.toString(),
      items: items,
      itemsLabels: {
        for (final item in items ?? const <String>[])
          item: S.of(context).weekNumber(item),
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
