import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/role_chip.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/custom_user_avatar.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomUserAvatar(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const SizedBox(height: 4),
              Text(
                user.phone,
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ],
          ),
        ),
        Wrap(spacing: 4, children: user.roles.map(RoleChip.new).toList()),
      ],
    );
  }
}

