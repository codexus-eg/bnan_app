import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/features/admin/data/admin_dashboard_mock.dart';
import 'package:flutter/material.dart';

class AdminStatsSection extends StatelessWidget {
  const AdminStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = adminStats(context);

    return HomeStatsSection(
      states: stats,
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 16,
      // childAspectRatio: 101 / 87,
      titleTextAlign: TextAlign.center,
      titleOverflow: TextOverflow.ellipsis,
    );
  }
}
