import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_state_card.dart';
import 'package:flutter/material.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    super.key,
    required this.states, 
  
  });
  final List<HomeStateModel> states;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(states.length * 2 - 1, (index) {
        if (index.isOdd) {
          return const SizedBox(width: 20);
        }
        final itemIndex = index ~/ 2;
        return Expanded(
          child: HomeStatCard(
            state: states[itemIndex],
          ),
        );
      }),
    );
  }
}
