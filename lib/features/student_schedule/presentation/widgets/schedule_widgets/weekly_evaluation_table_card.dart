import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/weekly_evaluation_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationTableCard extends StatelessWidget {
  const WeeklyEvaluationTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).weeklyEvaluation,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color: ColorManager.greyF8F9,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withAlpha((255 * .25).round()),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const WeeklyEvaluationGrid(),
        ),
      ],
    );
  }
}