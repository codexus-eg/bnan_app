import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CancelSupervisorAssignmentDialog extends StatelessWidget {
  const CancelSupervisorAssignmentDialog({
    super.key,
    required this.classroomName,
  });

  final String classroomName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.cancelAssignment),
            const SizedBox(height: 16),
            Text(
              s.cancelSupervisorAssignmentQuestion(classroomName),
              textAlign: TextAlign.center,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    text: s.yes,
                    height: 40,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomAppButton(
                    text: s.no,
                    height: 40,
                    backgroundColor: ColorManager.white,
                    borderColor: ColorManager.blueE3,
                    textColor: ColorManager.mainColor15,
                    onPressed: () => Navigator.pop(context),
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
