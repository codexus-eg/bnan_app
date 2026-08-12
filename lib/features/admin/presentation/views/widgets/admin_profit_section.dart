import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_profit_group.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_money.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminProfitSection extends StatelessWidget {
  const AdminProfitSection({super.key, required this.revenue});
  final DashboardRevenue revenue;

  @override
  Widget build(BuildContext context) {
    final groups = [
      (S.of(context).dailyProfits, revenue.today),
      (S.of(context).monthlyRevenue, revenue.month),
    ].where((group) => group.$2.isNotEmpty).toList();
    return Column(
      children: [
        for (var index = 0; index < groups.length; index++) ...[
          AdminProfitGroup(
            title: groups[index].$1,
            states: groups[index].$2
                .map(
                  (money) => HomeStateModel(
                    icon: '',
                    value: money.amountLabel,
                    title: money.currency,
                  ),
                )
                .toList(),
          ),
          if (index < groups.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}
