import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomDetailsDialog extends StatelessWidget {
  const ClassroomDetailsDialog({super.key, required this.classroomItem});
  final ClassroomModel classroomItem;

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
                    value: classroomItem.name,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.grade,
                    value: classroomItem.grade.name,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.curriculum,
                    value: classroomItem.curriculum.name,
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.teachers,
                    value: _teacherNames(classroomItem),
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.theSupervisor,
                    value: classroomItem.supervisor?.name.isNotEmpty == true
                        ? classroomItem.supervisor!.name
                        : '-',
                    spacing: true,
                  ),
                  ClassMetaRow(
                    label: s.students,
                    value: '${classroomItem.approvedStudentsCount}',
                    spacing: true,
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

String _teacherNames(ClassroomModel classroom) {
  final names = classroom.teachers.map((teacher) => teacher.fullName).toList();
  return names.isEmpty ? '-' : names.join(' - ');
}
