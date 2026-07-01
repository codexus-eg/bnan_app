import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_dialog.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/details_dialog.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_dialog.dart';
import 'package:flutter/material.dart';

class UserDialogs {
  static Future<void> showDetails(BuildContext context, UserItem user) {
    return AppDialogs.show(
      context: context,
      child: DetailsDialog(user: user),
    );
  }

  static Future<void> showAdd(BuildContext context) {
    return AppDialogs.show(context: context, child: const FormDialog.add());
  }

  static Future<void> showEdit(BuildContext context, UserItem user) {
    return AppDialogs.show(
      context: context,
      child: FormDialog.edit(userName: user.name),
    );
  }

  static Future<void> showResetPassword(BuildContext context) {
    return AppDialogs.show(
      context: context,
      child: const FormDialog.resetPassword(),
    );
  }

  static Future<void> showDisable(BuildContext context, UserItem user) {
    return AppDialogs.show(
      context: context,
      child: ConfirmDialog.disable(userName: user.name),
    );
  }

  static Future<void> showDelete(BuildContext context) {
    return AppDialogs.show(
      context: context,
      child: const ConfirmDialog.delete(),
    );
  }
}
