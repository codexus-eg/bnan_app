import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/detail_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RoleRowSection extends StatelessWidget {
  const RoleRowSection({super.key, required this.s, required this.user});

  final S s;
  final UserItem user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DetailRow(
          label: s.userRole,
          icon: ImageManager.usersManagementShieldIcon,
        ),
        Customship(
          user.roles.first,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 3),
          style: StylesManager.styleRegular10(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
      ],
    );
  }
}
