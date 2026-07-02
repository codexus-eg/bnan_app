import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/table_dialog_dropdown.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/dialogs/table_file_picker_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddTableScheduleDialog extends StatelessWidget {
  const AddTableScheduleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.classSchedulesManagement),
            const SizedBox(height: 16),
            TableDialogDropdown(
              label: s.curriculum,
              initialValue: s.saudiCurriculum,
              items: [s.saudiCurriculum, s.egyptianCurriculum],
            ),
            const SizedBox(height: 16),
            TableDialogDropdown(
              label: s.grade,
              hint: s.selectGrade,
              items: [
                s.primaryGradeFive,
                s.parentFirstPreparatoryGrade,
                s.parentSecondPreparatoryGrade,
              ],
            ),
            const SizedBox(height: 16),
            TableDialogDropdown(
              label: s.subject,
              initialValue: s.arabic,
              items: [s.arabic, s.mathShort, s.english],
            ),
            const SizedBox(height: 16),
            TableFilePickerField(label: s.attachedFile, hint: s.selectFile),
            const SizedBox(height: 16),
            CustomAppButton(
              text: s.uploadSchedule,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
