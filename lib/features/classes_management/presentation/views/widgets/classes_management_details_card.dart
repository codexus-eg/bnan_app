import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/classes_management/data/models/class_management_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassesMnagementDetailsCard extends StatelessWidget {
  const ClassesMnagementDetailsCard({
    super.key,
    required this.s,
    required this.classItem,
  });

  final S s;
  final ClassManagementModel classItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClassMetaRow(
                label: s.curriculum,
                value: classItem.curriculum,
              ),
            ),
            Expanded(
              child: ClassMetaRow(
                label: s.students,
                value: '${classItem.studentsCount}',
              ),
            ),
          ],
        ),
        const SizedBox(width: 21),
        Row(
          children: [
            Expanded(
              child: ClassMetaRow(label: s.grade, value: classItem.grade),
            ),
            Expanded(
              child: ClassMetaRow(
                label: s.supervisor,
                value: classItem.supervisor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
