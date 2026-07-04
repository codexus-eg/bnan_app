import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_profit_cards.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_section_title.dart';
import 'package:flutter/material.dart';

class AdminProfitGroup extends StatelessWidget {
  const AdminProfitGroup({
    super.key,
    required this.title,
    required this.states,
  });

  final String title;
  final List<HomeStateModel> states;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminSectionTitle(
          title: title,
          showTrendIcon: true,
        ),
        const SizedBox(height: 8),
        AdminProfitCards(states: states),
      ],
    );
  }
}