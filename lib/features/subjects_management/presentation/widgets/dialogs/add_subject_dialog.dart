import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_dropdown.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/subject_dialog_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddSubjectDialog extends StatelessWidget {
  const AddSubjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.addNewSubject),
            const SizedBox(height: 16),
            SubjectDialogField(label: s.subjectName),
            const SizedBox(height: 16),
            SubjectDialogDropdown(
              label: s.curriculum,
              items: [s.saudiCurriculum, s.egyptianCurriculum],
            ),
            const SizedBox(height: 16),
            SubjectDialogDropdown(
              label: s.grade,
              items: [
                s.primaryGradeFive,
                s.parentFirstPreparatoryGrade,
                s.parentSecondPreparatoryGrade,
              ],
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
