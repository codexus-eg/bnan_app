import 'package:bnan_app/features/admin/data/admin_actions_mock.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_quick_action_card.dart';
import 'package:flutter/material.dart';

class AdminQuickActionsSection extends StatelessWidget {
  const AdminQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = adminQuickActions(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: actions.map((action) {
            return SizedBox(
              width: width,
              child: AdminQuickActionCard(action: action),
            );
          }).toList(),
        );
      },
    );
  }
}
