import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/dialogs/add_grade_dialog.dart';
import 'package:bnan_app/features/grades_management/presentation/views/widgets/dialogs/delete_grade_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GradesManagementBody extends StatelessWidget {
  const GradesManagementBody({super.key});

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
            onTap: () => _showAddGradeDialog(context),
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
              itemCount: gradeMockData.length,
              itemBuilder: (context, index) {
                return DetailsRowSection(
                  iconPath: ImageManager.teacherCurriculm,
                  title: gradeMockData[index].name,
                  subtitle: gradeMockData[index].curriculm,
                  onTap: () => _showDeleteGradeDialog(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGradeDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddGradeDialog());
  }

  void _showDeleteGradeDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const DeleteGradeDialog());
  }
}
