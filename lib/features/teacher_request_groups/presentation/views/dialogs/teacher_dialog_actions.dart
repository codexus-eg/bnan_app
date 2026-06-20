import 'package:bnan_app/features/teacher_request_groups/presentation/views/dialogs/teacher_dialog_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherDialogActions extends StatelessWidget {
  const TeacherDialogActions({super.key, this.onAccept});

  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TeacherDialogButton(
            title: S.of(context).cancel,
            isPrimary: false,
            onTap: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: TeacherDialogButton(
            title: S.of(context).accept,
            isPrimary: true,
            onTap: onAccept,
          ),
        ),
      ],
    );
  }
}
