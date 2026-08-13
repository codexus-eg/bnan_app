import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_choices.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_content.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_error_message.dart';
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
    return BlocConsumer<UsersManagementCubit, UsersManagementState>(
      listenWhen: (_, state) =>
          state is UsersActionSuccess && _isCurrentAction(state.action),
      listener: (context, _) => Navigator.pop(context),
      builder: (context, state) {
        final loading =
            state is UsersActionLoading &&
            state.action ==
                (isDelete
                    ? UsersManagementAction.delete
                    : UsersManagementAction.status);
        final failure =
            state is UsersActionFailure && _isCurrentAction(state.action)
            ? state.message
            : null;
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
                if (failure != null) ...[
                  const SizedBox(height: 12),
                  DialogErrorMessage(message: failure),
                ],
                if (isDelete) ...[
                  const SizedBox(height: 18),
                  CustomAppButton(
                    text: s.finalDelete,
                    backgroundColor: ColorManager.redBA,
                    isLoading: loading,
                    onPressed: loading ? null : () => _onConfirm(context),
                  ),
                ] else
                  ConfirmChoices(
                    isLoading: loading,
                    onYes: loading ? null : () => _onConfirm(context),
                    onNo: loading ? null : () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onConfirm(BuildContext context) {
    final cubit = context.read<UsersManagementCubit>();
    if (isDelete) {
      cubit.deleteUser(userId: user.id);
    } else {
      cubit.updateUserStatus(user: user);
    }
  }

  bool _isCurrentAction(UsersManagementAction action) {
    return action ==
        (isDelete
            ? UsersManagementAction.delete
            : UsersManagementAction.status);
  }
}
