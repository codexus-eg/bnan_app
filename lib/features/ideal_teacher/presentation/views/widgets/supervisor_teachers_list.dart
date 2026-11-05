import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_card.dart';
import 'package:flutter/material.dart';

class SupervisorTeachersList extends StatelessWidget {
  const SupervisorTeachersList({
    super.key,
    required this.teachers,
    required this.selectedIds,
    required this.canSelect,
    required this.onToggle,
    this.scrollController,
  });

  final List<SupervisorTeacherModel> teachers;
  final Set<String> selectedIds;
  final bool canSelect;
  final ValueChanged<String>? onToggle;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
    itemCount: teachers.length,
    itemBuilder: (_, index) {
      final item = teachers[index];
      return IdealTeacherCard(
        key: Key('supervisor-teacher-${item.id}'),
        teacher: item,
        selected: selectedIds.contains(item.id),
        canSelect: canSelect,
        onTap: onToggle == null ? null : () => onToggle!(item.id),
      );
    },
  );
}
