import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/confirm_dialog.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/details_dialog.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDialogs {
  static Future<void> showDetails(BuildContext context, UserItem user) {
    return AppDialogs.show(
      context: context,
      child: DetailsDialog(user: user),
    );
  }

  static Future<void> showAdd(BuildContext context) {
    final cubit = context.read<UsersManagementCubit>()..prepareAdd();
    return AppDialogs.show(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: const FormDialog.add(),
      ),
    );
  }

  static Future<void> showEdit(BuildContext context, UserItem user) {
    final cubit = context.read<UsersManagementCubit>()..prepareEdit(user);
    return AppDialogs.show(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: FormDialog.edit(user: user),
      ),
    );
  }

  static Future<void> showResetPassword(BuildContext context, UserItem user) {
    final cubit = context.read<UsersManagementCubit>();
    return AppDialogs.show(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: FormDialog.resetPassword(user: user),
      ),
    );
  }

  static Future<void> showDisable(BuildContext context, UserItem user) {
    final cubit = context.read<UsersManagementCubit>();
    return AppDialogs.show(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: ConfirmDialog.disable(user: user),
      ),
    );
  }

  static Future<void> showDelete(BuildContext context, UserItem user) {
    final cubit = context.read<UsersManagementCubit>();
    return AppDialogs.show(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: ConfirmDialog.delete(user: user),
      ),
    );
  }
}
