import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_fields.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class FormDialog extends StatelessWidget {
  const FormDialog.add({super.key}) : mode = FormMode.add, userName = null;

  const FormDialog.edit({super.key, required this.userName})
    : mode = FormMode.edit;

  const FormDialog.resetPassword({super.key})
    : mode = FormMode.password,
      userName = null;

  final FormMode mode;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: title(s)),
            const SizedBox(height: 16),
            FormFields(mode: mode, userName: userName),
            const SizedBox(height: 16),
            CustomAppButton(
              text: s.save,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String title(S s) {
    if (mode == FormMode.add) return s.addNewUser;
    if (mode == FormMode.edit) return s.editData;
    return s.resetPassword;
  }
}
