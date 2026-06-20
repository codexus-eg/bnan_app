import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/dialogs/teacher_dialog_actions.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/dialogs/teacher_request_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AcceptRegistrationRequestDialog extends StatelessWidget {
  const AcceptRegistrationRequestDialog({
    super.key,
    required this.studentName,
    this.onAccept,
  });

  final String studentName;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 49,
              width: 49,
              child: CustomIconBox(imagePath: ImageManager.bellIcon),
            ),
            const SizedBox(height: 8),
            TeacherRequestDialogHeader(studentName: studentName),
            const SizedBox(height: 8),
            SizedBox(
              width: 270,
              child: Text(
                S.of(context).studentRequestAccepted,
                textAlign: TextAlign.center,
                style: StylesManager.styleRegular16(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ),
            const SizedBox(height: 8),
            TeacherDialogActions(onAccept: onAccept),
          ],
        ),
      ),
    );
  }
}


