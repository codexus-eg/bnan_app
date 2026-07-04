import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/classroom_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classroom_management/presentation/views/widgets/dialogs/add_classroom_dialog.dart';
import 'package:bnan_app/features/classroom_management/presentation/views/widgets/dialogs/delete_classroom_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomManagementBody extends StatelessWidget {
  const ClassroomManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AddNewTopicButton(
            title: S.of(context).addNewGrade,
            path: ImageManager.plus,
            onTap: () => _showAddClassroomDialog(context),
            padding: EdgeInsetsDirectional.only(
              start: 20,
              end: 27,
              top: 8,
              bottom: 8,
            ),
          ),
          CustomDetailsWidgetBackground(
            margin: EdgeInsetsDirectional.symmetric(vertical: 16),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: classRoomMockData.length,
              itemBuilder: (context, index) {
                return DetailsRowSection(
                  iconPath: ImageManager.teacherCurriculm,
                  title: classRoomMockData[index].name,
                  subtitle: classRoomMockData[index].curriculm,
                  onTap: () => _showDeleteClassroomDialog(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClassroomDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddClassroomDialog());
  }

  void _showDeleteClassroomDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const DeleteClassroomDialog());
  }
}
