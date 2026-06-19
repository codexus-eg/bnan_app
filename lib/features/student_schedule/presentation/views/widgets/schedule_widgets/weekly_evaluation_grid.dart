import 'package:bnan_app/features/student_schedule/presentation/views/widgets/schedule_widgets/schedule_cell.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationGrid extends StatelessWidget {
  const WeeklyEvaluationGrid({super.key});

  static const double subjectColumnWidth = 72;
  static const double valueColumnWidth = 68;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final headers = [
      s.subject,
      s.attendance,
      s.participation,
      s.assignments,
      s.subject,
      s.attendance,
      s.participation,
      s.assignments,
    ];

    final rows = [
      _EvaluationRow(
        subject: s.arabicLanguage,
        values: [s.absent, s.excellent, s.excellent],
      ),
      _EvaluationRow(subject: s.english, values: ['-', '-', '-']),
      _EvaluationRow(
        subject: s.arabicLanguage,
        values: [s.absent, s.excellent, s.excellent],
      ),
      _EvaluationRow(
        subject: s.arabicLanguage,
        values: [s.absent, s.excellent, s.excellent],
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          _EvaluationHeaderRow(headers: headers),
          ...rows.map((row) {
            return _EvaluationDataRow(
              row: row,
              valuesCount: headers.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _EvaluationHeaderRow extends StatelessWidget {
  const _EvaluationHeaderRow({required this.headers});

  final List<String> headers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScheduleCell(
          text: headers.first,
          width: WeeklyEvaluationGrid.subjectColumnWidth,
          isHeader: true,
          isDark: true,
        ),
        ...headers.skip(1).map((header) {
          return ScheduleCell(
            text: header,
            width: WeeklyEvaluationGrid.valueColumnWidth,
            isHeader: true,
            isDark: true,
          );
        }),
      ],
    );
  }
}

class _EvaluationDataRow extends StatelessWidget {
  const _EvaluationDataRow({required this.row, required this.valuesCount});

  final _EvaluationRow row;
  final int valuesCount;

  @override
  Widget build(BuildContext context) {
    final values = _completeValues(row.values, valuesCount);

    return Row(
      children: [
        ScheduleCell(
          text: row.subject,
          width: WeeklyEvaluationGrid.subjectColumnWidth,
          isHeader: true,
          isDark: true,
        ),
        ...values.map((value) {
          return ScheduleCell(
            isEvaluation: true,
            text: value,
            width: WeeklyEvaluationGrid.valueColumnWidth,
          );
        }),
      ],
    );
  }

  List<String> _completeValues(List<String> values, int count) {
    if (values.length >= count) return values.take(count).toList();

    return [...values, ...List.generate(count - values.length, (_) => '-')];
  }
}

class _EvaluationRow {
  const _EvaluationRow({required this.subject, required this.values});

  final String subject;
  final List<String> values;
}
