import 'package:bnan_app/features/ideal_supervisor/presentation/views/widgets/ideal_supervisor_card.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:flutter/material.dart';

class IdealSupervisorList extends StatelessWidget {
  const IdealSupervisorList({
    super.key,
    required this.supervisors,
    required this.selectedIds,
    required this.onToggle,
  });
  final List<SupervisorModel> supervisors;
  final Set<String> selectedIds;
  final ValueChanged<String>? onToggle;

  @override
  Widget build(BuildContext context) => ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
    itemCount: supervisors.length,
    itemBuilder: (_, index) {
      final supervisor = supervisors[index];
      return IdealSupervisorCard(
        key: Key('ideal-supervisor-${supervisor.id}'),
        supervisor: supervisor,
        selected: selectedIds.contains(supervisor.id),
        onTap: onToggle == null ? null : () => onToggle!(supervisor.id),
      );
    },
  );
}
