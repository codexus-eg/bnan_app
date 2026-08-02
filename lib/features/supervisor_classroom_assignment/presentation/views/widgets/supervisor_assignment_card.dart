import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/models/supervisor_assignment_ui_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/assign_supervisor_dialog.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/cancel_supervisor_assignment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorAssignmentCard extends StatelessWidget {
  const SupervisorAssignmentCard({super.key, required this.supervisor});

  final SupervisorAssignmentUiModel supervisor;

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
                  supervisor.name,
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
                  builder: (_) =>
                      AssignSupervisorDialog(supervisorName: supervisor.name),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...supervisor.assignments.map(
            (assignment) => DetailsRowSection(
              iconPath: ImageManager.teacherBookTwoIcon,
              title: assignment.classroomName,
              subtitle: assignment.curriculumName,
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => CancelSupervisorAssignmentDialog(
                  classroomName: assignment.classroomName,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
