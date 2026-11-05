import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeleteClassroomSubjectDialog extends StatelessWidget {
  const DeleteClassroomSubjectDialog({super.key, required this.subjectName});
  final String subjectName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDialogHeader(title: s.deleteSubject),
            const SizedBox(height: 16),
            Text('${s.deleteSubjectConfirmation}\n($subjectName)',
                style: StylesManager.styleRegular14(context),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    text: s.cancel,
                    backgroundColor: ColorManager.greyD9D9,
                    textColor: ColorManager.mainColor14,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    text: s.delete,
                    backgroundColor: ColorManager.red,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
