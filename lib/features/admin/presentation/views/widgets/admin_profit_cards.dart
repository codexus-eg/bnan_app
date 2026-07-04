import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class AdminProfitCards extends StatelessWidget {
  const AdminProfitCards({super.key, required this.states});

  final List<HomeStateModel> states;

  @override
  Widget build(BuildContext context) {
    return HomeStatsSection(
      states: states,
      crossAxisCount: 2,
      crossAxisSpacing: 35,
      mainAxisSpacing: 0,
      childAspectRatio: 154/59,
      showIcon: false,
      titleTextAlign: TextAlign.center,
      titleOverflow: TextOverflow.ellipsis,
      titleColorBuilder: (index) =>
          index == 0 ? ColorManager.black : ColorManager.redD5,
    );
  }
}
