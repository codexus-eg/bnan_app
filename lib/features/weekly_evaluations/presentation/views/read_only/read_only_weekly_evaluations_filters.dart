import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_child_filter.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_week_filter.dart';
import 'package:flutter/material.dart';

class ReadOnlyWeeklyEvaluationsFilters extends StatelessWidget {
  const ReadOnlyWeeklyEvaluationsFilters({super.key, required this.state});
  final ReadOnlyWeeklyEvaluationsState state;

  @override
  Widget build(BuildContext context) {
    final filters = [
      ReadOnlyChildFilter.fromState(state),
      ReadOnlyWeekFilter.fromState(state),
    ].whereType<Widget>().toList();
    if (filters.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < 520
          ? Column(
              children: [
                for (final filter in filters) ...[
                  filter,
                  if (filter != filters.last) const SizedBox(height: 12),
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final filter in filters) ...[
                  Expanded(child: filter),
                  if (filter != filters.last) const SizedBox(width: 12),
                ],
              ],
            ),
    );
  }
}
