import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plan_subject_cell.dart';
import 'package:flutter/material.dart';

class WeeklyPlanDayRow extends StatelessWidget {
  const WeeklyPlanDayRow({
    super.key,
    required this.day,
    required this.subjectNames,
    required this.dayWidth,
    required this.subjectWidth,
  });

  final PlanDayUiModel day;
  final List<String> subjectNames;
  final double dayWidth;
  final double subjectWidth;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: dayWidth,
            child: Container(
              margin: const EdgeInsetsDirectional.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorManager.mainColor14,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                day.dayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleBold10(
                  context,
                ).copyWith(color: ColorManager.white),
              ),
            ),
          ),
          ...subjectNames.map(
            (name) => PlanSubjectCell(
              subject: day.subjectByName(name),
              width: subjectWidth,
            ),
          ),
        ],
      ),
    );
  }
}
