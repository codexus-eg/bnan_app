import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/classes_management/data/models/class_management_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassDetailsDialog extends StatelessWidget {
  const ClassDetailsDialog({super.key, required this.classItem});
  final ClassManagementModel classItem;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(title: s.classDetails),
            const SizedBox(height: 16),
            CustomDetailsWidgetBackground(
              child: Column(
                children: [
                  ClassMetaRow(
                    label: s.className,
                    value: classItem.title,
                    spacing: true,
                  ),
                  ClassMetaRow(label: s.grade, value: classItem.grade, spacing: true),
                  ClassMetaRow(
                    label: s.curriculum,
                    value: classItem.curriculum,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.teachers,
                    value: classItem.teachers,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.theSupervisor,
                    value: classItem.supervisor,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.students,
                    value: '${classItem.studentsCount}',
                    spacing: true
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
