import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/detail_row.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/role_row_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DialogDetailsBody extends StatelessWidget {
  const DialogDetailsBody({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDetailsWidgetBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(
            label: s.email,
            value: user.email,
            showCopy: true,
            icon: ImageManager.usersManagementEmailIcon,
          ),
          DetailRow(
            label: s.phoneNumber,
            value: user.phone,
            showCopy: true,
            icon: ImageManager.usersManagementPhoneIcon,
          ),
          DetailRow(
            label: s.password,
            value: 'غير متاحة',
            icon: ImageManager.usersManagementKeyIcon,
          ),
          DetailRow(
            label: s.registrationDate,
            value: user.registrationDate,
            icon: ImageManager.usersManagementCalendarIcon,
          ),
          RoleRowSection(s: s, user: user),
        ],
      ),
    );
  }
}
