import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
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
    final style = StylesManager.styleBold12(context);
    return CustomTableRow(
      equalHeight: true,
      children: [
        CustomTableCell(
          width: dayWidth,
          height: null,
          constraints: const BoxConstraints(minHeight: 29),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          borderRadius: BorderRadius.circular(10),
          backgroundColor: ColorManager.blueE3,
          child: Text(
            S.of(context).today,
            textAlign: TextAlign.center,
            softWrap: true,
            style: style.copyWith(color: ColorManager.greyA8AF),
          ),
        ),
        ...subjectNames.map(
          (name) => CustomTableCell(
            width: subjectWidth,
            height: null,
            constraints: const BoxConstraints(minHeight: 29),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            borderRadius: BorderRadius.circular(10),
            backgroundColor: ColorManager.mainColor14,
            child: Text(
              name,
              textAlign: TextAlign.center,
              softWrap: true,
              style: style.copyWith(color: ColorManager.white),
            ),
          ),
        ),
      ],
    );
  }
}
