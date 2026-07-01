import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/custom_user_avatar.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_details_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DetailsDialog extends StatelessWidget {
  const DetailsDialog({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.userDetails),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomUserAvatar(),
                const SizedBox(width: 8),
                Text(
                  user.name,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DialogDetailsBody(user: user),
          ],
        ),
      ),
    );
  }
}
