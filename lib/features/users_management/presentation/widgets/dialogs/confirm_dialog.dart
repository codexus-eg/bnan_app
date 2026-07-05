import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_choices.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog.disable({super.key, required this.user})
    : isDelete = false;

  const ConfirmDialog.delete({super.key, required this.user}) : isDelete = true;

  final UserItem user;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isActive = user.status.toLowerCase() == 'active';
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(
              title: isDelete
                  ? s.finalDeleteUser
                  : isActive
                  ? s.disableAccount
                  : s.enableAccount,
            ),
            const SizedBox(height: 16),
            ConfirmContent(isDelete: isDelete, user: user),
            if (!isDelete) const ConfirmChoices(),
            const SizedBox(height: 18),
            CustomAppButton(
              text: isDelete ? s.finalDelete : s.save,
              backgroundColor: isDelete ? ColorManager.redBA : null,
              onPressed: () => _onConfirm(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm(BuildContext context) async {
    final cubit = context.read<UsersManagementCubit>();
    if (isDelete) {
      await cubit.deleteUser(userId: user.id);
    } else {
      await cubit.updateUserStatus(user: user);
    }

    if (context.mounted) Navigator.pop(context);
  }
}
