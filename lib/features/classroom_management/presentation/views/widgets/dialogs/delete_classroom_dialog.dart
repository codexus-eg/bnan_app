import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeleteClassroomDialog extends StatelessWidget {
  const DeleteClassroomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.deleteGrade),
            const SizedBox(height: 16),
            Text(
              s.deleteGradeConfirmation,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
            const SizedBox(height: 16),
            CustomAppButton(
              text: s.delete,
              backgroundColor: ColorManager.redBA,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
