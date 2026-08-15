import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomsManagementDetailsCard extends StatelessWidget {
  const ClassroomsManagementDetailsCard({
    super.key,
    required this.s,
    required this.classroomItem,
  });

  final S s;
  final ClassroomModel classroomItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ClassMetaRow(
                label: s.curriculum,
                value: classroomItem.curriculum.name,
              ),
            ),
            Expanded(
              child: ClassMetaRow(
                label: s.students,
                value: '${classroomItem.approvedStudentsCount}',
              ),
            ),
          ],
        ),
        const SizedBox(width: 21),
        Row(
          children: [
            Expanded(
              child: ClassMetaRow(
                label: s.grade,
                value: classroomItem.grade.name,
              ),
            ),
            Expanded(
              child: ClassMetaRow(
                label: s.supervisor,
                value: classroomItem.supervisor?.name.isNotEmpty == true
                    ? classroomItem.supervisor!.name
                    : '-',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
