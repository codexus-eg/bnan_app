import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
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
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor15),
        ),
        const SizedBox(height: 8),
        CustomTableContainer(
          shadowBlurRadius: 4,
          shadowOffset: const Offset(0, 4),
          child: const WeeklyEvaluationGrid(),
        ),
      ],
    );
  }
}
