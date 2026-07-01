import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/features/admin/data/admin_profit_mock.dart';
import 'package:bnan_app/features/admin/data/admin_subscription_mock.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_profit_cards.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_section_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminProfitSection extends StatelessWidget {
  const AdminProfitSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        AdminSectionTitle(title: s.dailyProfits, showTrendIcon: true),
        const SizedBox(height: 8),
        AdminProfitCards(states: adminDailyProfitStats(context)),
        const SizedBox(height: 16),
        AdminSectionTitle(title: s.monthlyProfits, showTrendIcon: true),
        const SizedBox(height: 8),
        AdminProfitCards(states: adminMonthlyProfitStats(context)),
        const SizedBox(height: 16),
        HomeStatsSection(
          states: adminSubscriptionStats(context),
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 0,
          childAspectRatio: .98,
          titleTextAlign: TextAlign.center,
          titleOverflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
