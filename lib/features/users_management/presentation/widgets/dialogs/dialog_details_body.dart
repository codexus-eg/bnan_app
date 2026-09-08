import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/helper/clipboard_helper.dart';
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
          if (user.id.isNotEmpty)
            _copyRow(
              context,
              'ID',
              user.id,
              ImageManager.usersManagementUserIcon,
            ),
          if (user.email.isNotEmpty)
            _copyRow(
              context,
              s.email,
              user.email,
              ImageManager.usersManagementEmailIcon,
            ),
          if (user.phone.isNotEmpty)
            _copyRow(
              context,
              s.phoneNumber,
              user.phone,
              ImageManager.usersManagementPhoneIcon,
            ),
          ..._extraRows(context, s),
          if (user.roles.isNotEmpty) RoleRowSection(s: s, user: user),
        ],
      ),
    );
  }

  DetailRow _copyRow(
    BuildContext context,
    String label,
    String value,
    String icon,
  ) => DetailRow(
    label: label,
    value: value,
    showCopy: true,
    onCopy: () => ClipboardHelper.copy(context, value),
    icon: icon,
  );

  List<Widget> _extraRows(BuildContext context, S s) {
    final rawDate = user.registrationDate.isNotEmpty
        ? user.registrationDate
        : user.createdAt;
    final formattedDate = AppPickers.formatDateTime(rawDate, context: context);
    final values = <({String label, String value})>[
      (label: s.status, value: user.status),
      (label: s.registrationMode, value: user.registrationMode),
      (label: s.registrationDate, value: formattedDate),
      (label: s.curriculums, value: user.curriculum.join(', ')),
      (label: s.classes, value: user.grade.join(', ')),
      (label: s.parent, value: user.parentName),
    ];
    return values
        .where((item) => item.value.trim().isNotEmpty)
        .map(
          (item) => DetailRow(
            label: item.label,
            value: item.value,
            icon: ImageManager.usersManagementUserIcon,
          ),
        )
        .toList(growable: false);
  }
}
