import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignments_filter_type.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignments_filter_chip.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentsFilterTabs extends StatelessWidget {
  const AssignmentsFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final AssignmentsFilterType selectedFilter;
  final ValueChanged<AssignmentsFilterType> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = {
      AssignmentsFilterType.all: S.of(context).all,
      AssignmentsFilterType.pending: S.of(context).pending,
      AssignmentsFilterType.completed: S.of(context).completed,
    };

    return Container(
      height: 49,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: filters.entries.map((entry) {
          return AssignmentsFilterChip(
            title: entry.value,
            isSelected: selectedFilter == entry.key,
            onTap: () => onChanged(entry.key),
          );
        }).toList(),
      ),
    );
  }
}
