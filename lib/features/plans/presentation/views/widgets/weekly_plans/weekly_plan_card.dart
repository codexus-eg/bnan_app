import 'dart:math' as math;

import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/features/plans/presentation/models/weekly_plan_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_day_row.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_header.dart';
import 'package:flutter/material.dart';

class WeeklyPlanCard extends StatelessWidget {
  const WeeklyPlanCard({super.key, required this.plan});

  static const double _dayWidth = 63;
  static const double _minimumSubjectWidth = 125;
  static const double _cellHorizontalMargin = 20;

  final WeeklyPlanUiModel plan;

  @override
  Widget build(BuildContext context) {
    return CustomTableContainer(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = math.max(1, plan.subjectNames.length);
          final dayOuterWidth = _dayWidth + _cellHorizontalMargin;
          final available = (constraints.maxWidth - dayOuterWidth) / count;
          final subjectWidth = math
              .max(_minimumSubjectWidth, available - _cellHorizontalMargin)
              .toDouble();
          final tableWidth =
              dayOuterWidth + (subjectWidth + _cellHorizontalMargin) * count;
          return SingleChildScrollView(
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
          );
        },
      ),
    );
  }
}
