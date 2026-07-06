import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/dialogs/grade_dialog_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddGradeDialog extends StatelessWidget {
  const AddGradeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.addNewGrade),
            const SizedBox(height: 16),
            GradeDialogDropdown(
              label: s.curriculum,
              items: [s.saudiCurriculum, s.egyptianCurriculum],
              initialValue: s.saudiCurriculum,
            ),
            const SizedBox(height: 16),
            GradeDialogDropdown(
              label: s.grade,
              items: [
                s.parentFirstPreparatoryGrade,
                s.parentSecondPreparatoryGrade,
              ],
              initialValue: s.parentFirstPreparatoryGrade,
            ),
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
}
