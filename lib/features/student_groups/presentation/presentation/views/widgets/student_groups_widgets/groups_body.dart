import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_groups/data/models/active_group_model.dart';
import 'package:bnan_app/features/student_groups/data/models/group_request_model.dart';
import 'package:bnan_app/features/student_groups/data/models/pending_request_model.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/shared_widgets/shared_group_header.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/accepted_request_card.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/active_group_card.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/groups_section_title.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/pending_request_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GroupsBody extends StatelessWidget {
  const GroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        SharedGroupHeader(
          title: S.of(context).myGroups,
          path: Routes.requestLesson,
          badgeTitle: ImageManager.plusIcon,
          isIcon: true,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            children: [
              AcceptedRequestCard(
                requests: [
                  GroupRequestModel(
                    teacherName: s.teacherSarahName,
                    subtitle: s.readyGroupSubtitle,
                  ),
                  GroupRequestModel(
                    teacherName: s.teacherAhmedFouad,
                    subtitle: s.readyGroupSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GroupsSectionTitle(title: s.pendingRequests),
              PendingRequestCard(
                request: PendingRequestModel(
                  subject: s.math,
                  subtitle: s.pendingMathSubtitle,
                ),
              ),
              const SizedBox(height: 12),
              PendingRequestCard(
                request: PendingRequestModel(
                  subject: s.science,
                  subtitle: s.pendingScienceSubtitle,
                ),
              ),
              const SizedBox(height: 16),
              GroupsSectionTitle(title: s.activeGroups),
              ActiveGroupCard(
                group: ActiveGroupModel(
                  title: s.mathTeacherSarah,
                  subtitle: s.groupCreatedByYou,
                ),
              ),
              const SizedBox(height: 16),
              ActiveGroupCard(
                group: ActiveGroupModel(
                  title: s.mathTeacherSarah,
                  subtitle: s.groupCreatedByYou,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
