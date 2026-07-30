import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plan_header_cell.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyPlanHeader extends StatelessWidget {
  const WeeklyPlanHeader({
    super.key,
    required this.subjectNames,
    required this.dayWidth,
    required this.subjectWidth,
  });

  final List<String> subjectNames;
  final double dayWidth;
  final double subjectWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WeeklyPlanHeaderCell(
          text: S.of(context).day,
          width: dayWidth,
          backgroundColor: ColorManager.blueE3,
          textColor: ColorManager.greyA8AF,
        ),
        ...subjectNames.map(
          (name) => WeeklyPlanHeaderCell(
            text: name,
            width: subjectWidth,
            backgroundColor: ColorManager.mainColor14,
            textColor: ColorManager.white,
          ),
        ),
      ],
    );
  }
}
