import 'package:bnan_app/core/shared_widget/custom_empty_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/assignments_filter_type.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentsEmptyState extends StatelessWidget {
  const AssignmentsEmptyState({
    super.key,
    required this.selectedFilter,
  });

  final AssignmentsFilterType selectedFilter;

  @override
  Widget build(BuildContext context) {
    return CustomEmptyState(
      icon: Icons.assignment_outlined,
      title: _title(context),
      subtitle: _subtitle(context),
    );
  }

  String _title(BuildContext context) {
    switch (selectedFilter) {
      case AssignmentsFilterType.pending:
        return S.of(context).noPendingAssignments;

      case AssignmentsFilterType.completed:
        return S.of(context).noCompletedAssignments;

      case AssignmentsFilterType.all:
        return S.of(context).noAssignmentsYet;
    }
  }

  String _subtitle(BuildContext context) {
    switch (selectedFilter) {
      case AssignmentsFilterType.pending:
        return S.of(context).noPendingAssignmentsSubtitle;

      case AssignmentsFilterType.completed:
        return S.of(context).noCompletedAssignmentsSubtitle;

      case AssignmentsFilterType.all:
        return S.of(context).noAssignmentsYetSubtitle;
    }
  }
}