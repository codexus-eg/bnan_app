import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/add_curriculms_data_title.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/delete_icon_button.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/semester_chip.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GradeRow extends StatelessWidget {
  const GradeRow({
    super.key,
    required this.grade,
    required this.isExpanded,
    required this.onToggle,
    required this.onDelete,
    required this.onAddSemester,
    required this.onDeleteSemester,
  });

  final GradeModel grade;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onAddSemester;
  final void Function(int index) onDeleteSemester;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDetailsWidgetBackground(
      shadow: false,
      backgroundColor: ColorManager.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: ColorManager.greyA8AF,
                ),
              ),
              AddCurriculmsDataTitle(
                title: grade.name,
                subtitle: '${grade.semesters.length} ${S.of(context).classR}',
              ),
              Spacer(),
              DeleteIconButton(onTap: onDelete, size: 16),
            ],
          ),
          if (isExpanded) ...[
            Wrap(
              spacing: 20,
              runSpacing: 4,

              children: [
                for (final item in grade.semesters.indexed)
                  SemesterChip(
                    semester: item.$2,
                    onDelete: () => onDeleteSemester(item.$1),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: AddNewTopicButton(
                title: s.addNewSemester,
                path: ImageManager.plus,
                onTap: onAddSemester,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
