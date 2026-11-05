import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/component_score_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherRankingComponentsView extends StatelessWidget {
  const TeacherRankingComponentsView({
    super.key,
    required this.components,
  });

  final RankingComponentsModel components;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = [
      (s.attendanceScore, components.attendance),
      (s.punctualityScore, components.punctuality),
      (s.interactionPoints, components.interaction),
      (s.weeklyTasks, components.weeklyTasks),
      (s.gradingScore, components.grading),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((pair) {
          final label = pair.$1;
          final score = pair.$2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: StylesManager.styleRegular12(context).copyWith(
                    color: ColorManager.mainColor14,
                  ),
                ),
                Text(
                  '${score.points} / ${score.max}',
                  style: StylesManager.styleBold12(context).copyWith(
                    color: ColorManager.mainColor14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
