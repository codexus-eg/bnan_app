import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomDetailsDialogRows extends StatelessWidget {
  const ClassroomDetailsDialogRows({super.key, required this.classroomItem});
  final ClassroomModel classroomItem;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final teacherNames = classroomItem.teachers.map((t) => t.fullName).toList();
    final targets = classroomItem.sharedAcademicTargets;

    return Column(
      children: [
        ClassMetaRow(label: s.className, value: classroomItem.name, spacing: true),
        ClassMetaRow(
          label: s.classroomKind,
          value: classroomItem.isShared ? s.sharedClassroom : s.standardClassroom,
          spacing: true,
        ),
        ClassMetaRow(label: s.grade, value: classroomItem.grade.name, spacing: true),
        if (classroomItem.isShared && targets.isNotEmpty) ...[
          ClassMetaRow(label: s.firstGrade, value: targets[0].gradeName ?? targets[0].grade, spacing: true),
          if (targets.length > 1)
            ClassMetaRow(label: s.secondGrade, value: targets[1].gradeName ?? targets[1].grade, spacing: true),
        ],
        ClassMetaRow(label: s.curriculum, value: classroomItem.curriculum.name, spacing: true),
        ClassMetaRow(label: s.teachers, value: teacherNames.isEmpty ? '-' : teacherNames.join(' - '), spacing: true),
        ClassMetaRow(label: s.theSupervisor, value: classroomItem.supervisor?.name.isNotEmpty == true ? classroomItem.supervisor!.name : '-', spacing: true),
        ClassMetaRow(label: s.students, value: '${classroomItem.approvedStudentsCount}', spacing: true),
      ],
    );
  }
}
