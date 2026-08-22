import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_child_filter.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_classroom_filter.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_week_filter.dart';
import 'package:flutter/material.dart';

class ReadOnlyWeeklyEvaluationsFilters extends StatelessWidget {
  const ReadOnlyWeeklyEvaluationsFilters({super.key, required this.state});
  final ReadOnlyWeeklyEvaluationsState state;

  @override
  Widget build(BuildContext context) {
    final childFilter = ReadOnlyChildFilter.fromState(state);
    final filters = [
      ReadOnlyWeekFilter.fromState(state),
      ReadOnlyClassroomFilter.fromState(state),
    ].whereType<Widget>().toList();
    if (childFilter == null && filters.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        if (childFilter != null) ...[childFilter, const SizedBox(height: 12)],
        if (filters.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final filter in filters) ...[
                Expanded(child: filter),
                if (filter != filters.last) const SizedBox(width: 12),
              ],
            ],
          ),
      ],
    );
  }
}
