import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plan_subject_content.dart';
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
    return CustomTableRow(
      equalHeight: true,
      showDivider: true,
      children: [
        CustomTableCell(
          width: dayWidth,
          height: null,
          constraints: const BoxConstraints(minHeight: 29),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 0,
            vertical: 4,
          ),
          alignment: Alignment.center,
          backgroundColor: ColorManager.mainColor14,
          borderRadius: BorderRadius.circular(10),
          child: Text(
            day.dayName,
            textAlign: TextAlign.center,
            softWrap: true,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.white),
          ),
        ),
        ...subjectNames.map((name) {
          final subject = day.subjectByName(name);
          return CustomTableCell(
            width: subjectWidth,
            height: null,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsetsDirectional.all(4),
            alignment: AlignmentDirectional.topStart,
            child: subject == null
                ? Center(
                    child: Text(
                      '-',
                      softWrap: true,
                      style: StylesManager.styleBold18(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                  )
                : PlanSubjectContent(subject: subject),
          );
        }),
      ],
    );
  }
}
