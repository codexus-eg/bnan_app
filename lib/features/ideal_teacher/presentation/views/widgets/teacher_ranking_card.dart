import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_card_content.dart';
import 'package:flutter/material.dart';

class TeacherRankingCard extends StatelessWidget {
  const TeacherRankingCard({
    super.key,
    required this.teacher,
    required this.selected,
    required this.canModify,
    required this.canSelect,
    required this.onTap,
  });

  final TeacherRankingItemModel teacher;
  final bool selected, canModify, canSelect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: CustomDetailsWidgetBackground(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: const EdgeInsetsDirectional.all(12),
      backgroundColor: selected ? ColorManager.blueE5 : ColorManager.greyF8F9,
      child: TeacherRankingCardContent(
        teacher: teacher,
        selected: selected,
        canModify: canModify,
        canSelect: canSelect,
      ),
    ),
  );
}
