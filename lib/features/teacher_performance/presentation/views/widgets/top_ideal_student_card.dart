import 'package:bnan_app/core/shared_widget/home_card_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_performance/data/models/ideal_student_item_model.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/ideal_student_score_chip.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/ideal_student_text_column.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/top_winner_medal.dart';
import 'package:flutter/material.dart';

class TopIdealStudentCard extends StatelessWidget {
  const TopIdealStudentCard({super.key, required this.student});

  final IdealStudentItemModel student;

  @override
  Widget build(BuildContext context) {
    return HomeCardWidget(
      padding: EdgeInsetsDirectional.only(start: 8,end: 8,top: 12,bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopWinnerMedal(isCurrentUser: student.isCurrentUser),
          const SizedBox(width: 8),
          IdealStudentTextColumn(
            name: student.name,
            nameColor: ColorManager.white,
            bottom: Text(
              student.gradeLabel,
              style: StylesManager.styleMedium14(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ),
          const Spacer(),
          IdealStudentScoreChip(points: student.points),
        ],
      ),
    );
  }
}
