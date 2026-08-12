import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_card.dart';
import 'package:flutter/material.dart';

class IdealTeacherList extends StatelessWidget {
  const IdealTeacherList({
    super.key,
    required this.teachers,
    required this.selectedIds,
    required this.onToggle,
  });
  final List<SupervisorTeacherModel> teachers;
  final Set<String> selectedIds;
  final ValueChanged<String>? onToggle;

  @override
  Widget build(BuildContext context) => ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
    itemCount: teachers.length,
    itemBuilder: (_, index) {
      final teacher = teachers[index];
      return IdealTeacherCard(
        key: Key('ideal-teacher-${teacher.id}'),
        teacher: teacher,
        selected: selectedIds.contains(teacher.id),
        onTap: onToggle == null ? null : () => onToggle!(teacher.id),
      );
    },
  );
}
