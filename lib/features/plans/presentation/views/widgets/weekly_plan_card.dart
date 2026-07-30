import 'dart:math' as math;

import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plan_day_row.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plan_header.dart';
import 'package:flutter/material.dart';

class WeeklyPlanCard extends StatelessWidget {
  const WeeklyPlanCard({super.key, required this.plan});

  static const double _dayWidth = 66;
  static const double _minimumSubjectWidth = 120;

  final WeeklyPlanUiModel plan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = math.max(1, plan.subjectNames.length).toDouble();
        final available = (constraints.maxWidth - _dayWidth) / count;
        final subjectWidth = math
            .max(_minimumSubjectWidth, available)
            .toDouble();
        final tableWidth = _dayWidth + subjectWidth * count;
        return Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            border: Border.all(color: ColorManager.greyE8E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WeeklyPlanHeader(
                      subjectNames: plan.subjectNames,
                      dayWidth: _dayWidth,
                      subjectWidth: subjectWidth,
                    ),
                    ...plan.days.map(
                      (day) => WeeklyPlanDayRow(
                        day: day,
                        subjectNames: plan.subjectNames,
                        dayWidth: _dayWidth,
                        subjectWidth: subjectWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
