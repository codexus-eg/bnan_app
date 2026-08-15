import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/custom_user_avatar.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_details_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsDialog extends StatelessWidget {
  const DetailsDialog({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersManagementCubit, UsersManagementState>(
      builder: (context, state) {
        final details = state is GetUserDetailsSuccess && state.user != null
            ? state.user!
            : user;
        return _dialog(context, details);
      },
    );
  }

  Widget _dialog(BuildContext context, UserItem details) {
    final s = S.of(context);
    return CustomAppDialog(
      child: SingleChildScrollView(
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
                  Expanded(
                    child: Text(
                      details.name,
                      style: StylesManager.styleBold16(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DialogDetailsBody(user: details),
            ],
          ),
        ),
      ),
    );
  }
}
