import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/teacher_subject_mock_data.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/assign_subject_dialog.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/subject_assignment_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({super.key, required this.item});
  final TeacherSubjectAssignmentItem item;

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
                  item.teacherName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ),
              const SizedBox(width: 12),
              AddNewTopicButton(
                title: S.of(context).assignSubject,
                path: ImageManager.plus,
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AssignSubjectDialog(
                    teacherName: item.teacherName,
                  ),
                ),
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...item.assignments.map(
            (assignment) => SubjectAssignmentRow(assignment: assignment),
          ),
        ],
      ),
    );
  }
}
