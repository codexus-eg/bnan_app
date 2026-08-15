import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianScheduleWeekFilter extends StatelessWidget {
  const EgyptianScheduleWeekFilter({super.key, required this.state});
  final EgyptianScheduleState state;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(state.maxWeek!, (index) => '${index + 1}');
    final labels = {
      for (final item in items) item: S.of(context).weekNumber(item),
    };
    return CustomDropdown(
      label: S.of(context).selectWeek,
      value: '${state.selectedWeek}',
      items: items,
      itemsLabels: labels,
      useDefaultIcon: true,
      onChanged: state.status == EgyptianScheduleStatus.loading
          ? null
          : (value) {
              final week = int.tryParse(value ?? '');
              if (week != null) {
                context.read<EgyptianScheduleCubit>().selectWeek(week);
              }
            },
    );
  }
}
