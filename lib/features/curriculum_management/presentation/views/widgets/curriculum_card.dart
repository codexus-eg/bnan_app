import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_card_header.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_grades.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumCard extends StatelessWidget {
  const CurriculumCard({
    super.key,
    required this.curriculum,
    required this.isExpanded,
    required this.expandedGrades,
    required this.onToggle,
    required this.onDelete,
    required this.onAddGrade,
    required this.onDeleteGrade,
    required this.onAddSemester,
    required this.onDeleteSemester,
    required this.onToggleGrade,
  });

  final CurriculumModel curriculum;
  final bool isExpanded;
  final Set<String> expandedGrades;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onAddGrade;
  final void Function(int index) onDeleteGrade;
  final void Function(GradeModel grade) onAddSemester;
  final void Function(GradeModel grade, int index) onDeleteSemester;
  final void Function(String id) onToggleGrade;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      backgroundColor: ColorManager.greyF8F9,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AddNewTopicButton(
              title: S.of(context).addNewGrade,
              path: ImageManager.plus,
              onTap: onAddGrade,
              padding: EdgeInsetsDirectional.only(
                start: 20,
                end: 27,
                top: 8,
                bottom: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CurriculumCardHeader(
            curriculum: curriculum,
            isExpanded: isExpanded,
            onToggle: onToggle,
            onDelete: onDelete,
          ),
          const SizedBox(height: 8),
          if (isExpanded) ...[
            CurriculumGrades(
              curriculum: curriculum,
              expandedGrades: expandedGrades,
              onAddGrade: onAddGrade,
              onDeleteGrade: onDeleteGrade,
              onAddSemester: onAddSemester,
              onDeleteSemester: onDeleteSemester,
              onToggleGrade: onToggleGrade,
            ),
          ],
        ],
      ),
    );
  }
}
