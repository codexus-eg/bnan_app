import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmContent extends StatelessWidget {
  const ConfirmContent({
    super.key,
    required this.isDelete,
    required this.userName,
  });

  final bool isDelete;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final message = isDelete
        ? s.permanentlyDeleteFromSystem
        : s.disableUserQuestion(userName);
    final description = isDelete
        ? s.finalDeleteDescription
        : s.disableUserDescription;
    return Column(
      children: [
        Text(
          message,
          style: StylesManager.styleBold14(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: StylesManager.styleRegular12(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
