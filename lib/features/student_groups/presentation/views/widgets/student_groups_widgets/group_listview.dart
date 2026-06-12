import 'package:bnan_app/core/shared_widget/custom_empty_state.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/active_group_card.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/groups_section_title.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/pending_request_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GroupsListView extends StatelessWidget {
  const GroupsListView({
    super.key,
    required this.pendingEnrollments,
    required this.activeEnrollments,
  });

  final List<StudentEnrollmentModel> pendingEnrollments;
  final List<StudentEnrollmentModel> activeEnrollments;

  @override
  Widget build(BuildContext context) {
    final hasNoGroups = pendingEnrollments.isEmpty && activeEnrollments.isEmpty;

    if (hasNoGroups) {
      return CustomEmptyState(
        icon: Icons.groups_outlined,
        title: S.of(context).noGroupsYet,
        subtitle: S.of(context).noGroupsYetSubtitle,
      );
    }

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      children: [
        if (pendingEnrollments.isNotEmpty) ...[
          GroupsSectionTitle(title: S.of(context).pendingRequests),
          ...pendingEnrollments.map(
            (enrollment) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PendingRequestCard(enrollment: enrollment),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (activeEnrollments.isNotEmpty) ...[
          GroupsSectionTitle(title: S.of(context).activeGroups),
          ...activeEnrollments.map(
            (enrollment) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ActiveGroupCard(enrollment: enrollment),
            ),
          ),
        ],
      ],
    );
  }
}
