import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_item_model.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_student_rank_badge.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_student_rank_leading_icon.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_student_score_text.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_student_text_column.dart';
import 'package:flutter/material.dart';

class IdealStudentRankCard extends StatelessWidget {
  const IdealStudentRankCard({super.key, required this.student});
  final IdealStudentItemModel student;

  @override
  Widget build(BuildContext context) {
    final isFirst = student.rank == 1;
    final textColor = isFirst ? ColorManager.white : ColorManager.mainColor14;
    return CustomDetailsWidgetBackground(
      backgroundColor: isFirst
          ? ColorManager.mainColor14
          : ColorManager.greyF8F9,
      child: Row(
        children: [
          IdealStudentRankBadge(student: student),
          const SizedBox(width: 10),
          IdealStudentTextColumn(
            name: student.name,
            nameColor: textColor,
            bottom: IdealStudentScoreText(points: student.points),
          ),
          const Spacer(),
          IdealStudentRankLeadingIcon(isFirst: isFirst),
        ],
      ),
    );
  }
}
