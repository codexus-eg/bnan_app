import 'dart:math' as math;

import 'package:bnan_app/core/shared_widget/custom_table/custom_table_container.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table_header.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationTable extends StatelessWidget {
  const WeeklyEvaluationTable({super.key, required this.subjects});

  static const double subjectWidth = 112;
  static const double valueWidth = 88;
  static const double notesWidth = 144;
  static const double minimumWidth = 560;

  final List<WeeklyEvaluationSubjectUiModel> subjects;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final headers = [
      s.subject,
      s.attendance,
      s.participation,
      s.assignments,
      s.notesText,
    ];
    return CustomTableContainer(
      shadowBlurRadius: 1,
      shadowOffset: const Offset(0, 1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.max(minimumWidth, constraints.maxWidth);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeeklyEvaluationTableHeader(
                    headers: headers,
                    subjectWidth: subjectWidth,
                    valueWidth: valueWidth,
                    notesWidth: notesWidth,
                  ),
                  ...subjects.map(
                    (subject) => WeeklyEvaluationTableRow(
                      subject: subject,
                      subjectWidth: subjectWidth,
                      valueWidth: valueWidth,
                      notesWidth: notesWidth,
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
