import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmContent extends StatelessWidget {
  const ConfirmContent({super.key, required this.isDelete, required this.user});

  final bool isDelete;
  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isActive = user.status.toLowerCase() == 'active';
    final message = isDelete
        ? s.permanentlyDeleteFromSystem
        : isActive
        ? s.disableAccountConfirmation
        : s.enableAccountConfirmation;
    final description = isDelete
        ? s.finalDeleteDescription
        : isActive
        ? s.disableUserDescription
        : '';
    return Column(
      children: [
        Text(
          message,
          style: StylesManager.styleBold14(context),
          textAlign: TextAlign.center,
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            description,
            style: StylesManager.styleRegular12(context),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
