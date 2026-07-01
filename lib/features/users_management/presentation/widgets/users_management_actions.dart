import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialogs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UsersManagementActions extends StatelessWidget {
  const UsersManagementActions({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Expanded(
          child: AddNewTopicButton(
            secondColor:ColorManager.mainColor14 ,
            backgroundColor: ColorManager.secondaryColor ,
            title: s.usersCount('96'),
            path: ImageManager.usersManagementUserIcon,
          ),
        ),
        const SizedBox(width: 19),
        Expanded(
          child: AddNewTopicButton(
            title: s.addUser,
            path: ImageManager.userAdd,
            onTap: () => UserDialogs.showAdd(context),
          ),
        ),
      ],
    );
  }
}
