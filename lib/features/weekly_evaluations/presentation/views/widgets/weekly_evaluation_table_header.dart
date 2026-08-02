import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationTableHeader extends StatelessWidget {
  const WeeklyEvaluationTableHeader({
    super.key,
    required this.headers,
    required this.subjectWidth,
    required this.valueWidth,
    required this.notesWidth,
  });

  final List<String> headers;
  final double subjectWidth;
  final double valueWidth;
  final double notesWidth;

  @override
  Widget build(BuildContext context) {
    return CustomTableRow(
      children: List.generate(
        headers.length,
        (index) => CustomTableCell(
          width: index == 0
              ? subjectWidth
              : index == headers.length - 1
              ? notesWidth
              : valueWidth,
          height: 42,
          margin: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 8),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
          backgroundColor: ColorManager.mainColor14,
          child: Text(
            headers[index],
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.white),
          ),
        ),
      ),
    );
  }
}
