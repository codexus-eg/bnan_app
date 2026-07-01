import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_choices.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog.disable({super.key, required this.userName})
    : isDelete = false;

  const ConfirmDialog.delete({super.key}) : userName = '', isDelete = true;

  final String userName;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: isDelete ? s.finalDeleteUser : s.disable),
            const SizedBox(height: 16),
            ConfirmContent(isDelete: isDelete, userName: userName),
            if (!isDelete) const ConfirmChoices(),
            const SizedBox(height: 18),
            CustomAppButton(
              text: isDelete ? s.finalDelete : s.save,
              backgroundColor: isDelete ? ColorManager.redBA : null,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
