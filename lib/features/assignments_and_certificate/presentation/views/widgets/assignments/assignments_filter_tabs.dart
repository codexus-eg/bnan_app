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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: filters.entries.map((entry) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: AssignmentsFilterChip(
            title: entry.value,
            isSelected: selectedFilter == entry.key,
            onTap: () => onChanged(entry.key),
          ),
        );
      }).toList(),
    );
  }
}