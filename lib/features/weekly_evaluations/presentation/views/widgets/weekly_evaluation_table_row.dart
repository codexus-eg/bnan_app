import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_row.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationTableRow extends StatelessWidget {
  const WeeklyEvaluationTableRow({
    super.key,
    required this.subject,
    required this.subjectWidth,
    required this.valueWidth,
    required this.notesWidth,
  });

  final WeeklyEvaluationSubjectUiModel subject;
  final double subjectWidth;
  final double valueWidth;
  final double notesWidth;

  @override
  Widget build(BuildContext context) {
    final values = [
      subject.subjectName,
      subject.attendance,
      subject.participation,
      subject.homework,
      subject.notes,
    ];
    return CustomTableRow(
      children: List.generate(
        values.length,
        (index) => CustomTableCell(
          width: index == 0
              ? subjectWidth
              : index == values.length - 1
              ? notesWidth
              : valueWidth,
          height: 42,
          margin: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 8),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
          backgroundColor: index == 0
              ? ColorManager.mainColor14
              : ColorManager.white,
          child: Text(
            values[index].isEmpty ? '-' : values[index],
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular12(context).copyWith(
              color: index == 0 ? ColorManager.white : ColorManager.mainColor15,
            ),
          ),
        ),
      ),
    );
  }
}
