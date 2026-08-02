import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/models/supervisor_assignment_ui_data.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/supervisor_assignment_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorAssignmentBody extends StatelessWidget {
  const SupervisorAssignmentBody({super.key});

  @override
  Widget build(BuildContext context) {
    final supervisors = supervisorAssignmentUiData(S.of(context));

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemCount: supervisors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return SupervisorAssignmentCard(supervisor: supervisors[index]);
      },
    );
  }
}
