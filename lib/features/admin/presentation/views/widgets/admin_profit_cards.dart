import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:flutter/material.dart';

class AdminProfitCards extends StatelessWidget {
  const AdminProfitCards({super.key, required this.states});

  final List<HomeStateModel> states;

  @override
  Widget build(BuildContext context) {
    return HomeStatsSection(
      states: states,
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 12,
      childAspectRatio: 2.05,
      showIcon: false,
      titleTextAlign: TextAlign.center,
      titleOverflow: TextOverflow.ellipsis,
    );
  }
}
