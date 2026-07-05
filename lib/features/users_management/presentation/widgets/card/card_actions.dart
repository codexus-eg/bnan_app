import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialogs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CardActions extends StatelessWidget {
  const CardActions({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,

        children: [
          ActionChipButton(
            title: s.view,
            icon: ImageManager.usersManagementEyeOpenIcon,
            onTap: () => UserDialogs.showDetails(context, user),
          ),
          ActionChipButton(
            title: s.edit,
            icon: ImageManager.usersManagementEditIcon,
            onTap: () => UserDialogs.showEdit(context, user),
          ),
          ActionChipButton(
            title: _statusActionText(s),
            icon: ImageManager.usersManagementStopSignIcon,
            onTap: () => UserDialogs.showDisable(context, user),
          ),
          ActionChipButton(
            title: s.delete,
            width: 11,
            icon: ImageManager.trash,
            onTap: () => UserDialogs.showDelete(context, user),
          ),
          ActionChipButton(
            title: s.password,
            height: 9,
            width: 17.25,
            icon: ImageManager.usersManagementKeyIcon,
            onTap: () => UserDialogs.showResetPassword(context, user),
          ),
        ],
      ),
    );
  }

  String _statusActionText(S s) {
    return user.status.toLowerCase() == 'active'
        ? s.disableAccount
        : s.enableAccount;
  }
}
