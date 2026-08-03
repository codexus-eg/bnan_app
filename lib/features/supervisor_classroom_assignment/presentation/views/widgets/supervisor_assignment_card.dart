import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/assign_supervisor_dialog.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/cancel_supervisor_assignment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorAssignmentCard extends StatelessWidget {
  const SupervisorAssignmentCard({super.key, required this.supervisor});

  final SupervisorModel supervisor;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  supervisor.user?.fullName.isNotEmpty == true
                      ? supervisor.user!.fullName
                      : '-',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ),
              const SizedBox(width: 12),
              AddNewTopicButton(
                title: S.of(context).assignToClassroom,
                path: ImageManager.plus,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider(
                    create: (_) => AcademicLookupsCubit(
                      repo: getIt<AcademicLookupsRepo>(),
                      loadSubjectsOnClassroom: false,
                    ),
                    child: AssignSupervisorDialog(
                      getSupervisorsCubit: context.read<GetSupervisorsCubit>(),
                      actionsCubit: context
                          .read<SupervisorAssignmentActionsCubit>(),
                      supervisorId: supervisor.id,
                      supervisorName: supervisor.user?.fullName ?? '-',
                      curriculumId: supervisor.curriculum?.id ?? '',
                      curriculumName: supervisor.curriculum?.name ?? '',
                      assignedClassroomIds: supervisor.assignments
                          .map((item) => item.classroom?.id ?? '')
                          .where((id) => id.isNotEmpty)
                          .toSet(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...supervisor.assignments.map(
            (assignment) => DetailsRowSection(
              iconPath: ImageManager.teacherBookTwoIcon,
              title: assignment.classroom?.name ?? '-',
              subtitle:
                  assignment.curriculum?.name ??
                  supervisor.curriculum?.name ??
                  '-',
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => CancelSupervisorAssignmentDialog(
                  getSupervisorsCubit: context.read<GetSupervisorsCubit>(),
                  actionsCubit: context
                      .read<SupervisorAssignmentActionsCubit>(),
                  supervisorId: supervisor.id,
                  classroomId: assignment.classroom?.id ?? '',
                  classroomName: assignment.classroom?.name ?? '-',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
