import 'package:bnan_app/core/shared_widget/home_state/home_state_card.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_stats_data.dart';
import 'package:flutter/material.dart';

class ParentHomeStatsSection extends StatelessWidget {
  const ParentHomeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = parentHomeStats(context);

    return Row(
      children: List.generate(stats.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == stats.length - 1 ? 0 : 20,
            ),
            child: HomeStatCard(state: stats[index]),
          ),
        );
      }),
    );
  }
}
