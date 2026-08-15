import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentScheduleWeekSelector extends StatelessWidget {
  const ParentScheduleWeekSelector({
    super.key,
    required this.selectedWeek,
    required this.maxWeek,
    required this.loading,
    required this.onChanged,
  });

  final int? selectedWeek, maxWeek;
  final bool loading;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(maxWeek ?? 0, (index) => '${index + 1}');
    return CustomDropdown(
      label: S.of(context).selectWeek,
      value: selectedWeek?.toString(),
      items: items,
      itemsLabels: {
        for (final item in items) item: S.of(context).weekNumber(item),
      },
      useDefaultIcon: true,
      onChanged: loading
          ? null
          : (value) {
              final week = int.tryParse(value ?? '');
              if (week != null) onChanged(week);
            },
    );
  }
}
