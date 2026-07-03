import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/card_actions.dart';
import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/meta_section.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        children: [
          CardHeader(name: user.name, phone:user.phone, subtitle: user.roles,),
          const SizedBox(height: 8),
          MetaSection(user: user),
          const SizedBox(height: 8),
          CardActions(user: user),
        ],
      ),
    );
  }
}
