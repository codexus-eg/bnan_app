import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'submit_correction_grade_field.dart';

class SubmitCorrectionForm extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final gradeController = TextEditingController();
  SubmitCorrectionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(title: S.of(context).submitAssignmentCorrection,style: StylesManager.styleRegular16(context).copyWith(
              color: ColorManager.greyA8AF
            )),
            const SizedBox(height: 16),
            Text('أحمد محمد', style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.mainColor14
            )),
            const SizedBox(height: 16),
            SubmitCorrectionGradeField(controller: gradeController),
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).sendCorrection,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
