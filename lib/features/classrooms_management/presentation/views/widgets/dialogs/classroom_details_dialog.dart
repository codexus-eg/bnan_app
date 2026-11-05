import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_details_dialog_rows.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomDetailsDialog extends StatelessWidget {
  const ClassroomDetailsDialog({super.key, required this.classroomItem});
  final ClassroomModel classroomItem;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(title: S.of(context).classDetails),
            const SizedBox(height: 16),
            CustomDetailsWidgetBackground(
              child: ClassroomDetailsDialogRows(classroomItem: classroomItem),
            ),
          ],
        ),
      ),
    );
  }
}
