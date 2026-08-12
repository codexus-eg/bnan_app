import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/home_student/data/models/evaluation_metric_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/evaluation_metric_row.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/teacher_note_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationSection extends StatelessWidget {
  const WeeklyEvaluationSection({super.key, required this.evaluation});
  final DashboardWeeklyEvaluation evaluation;

  @override
  Widget build(BuildContext context) {
    final values = [
      (S.of(context).attendanceRate, evaluation.attendance),
      (S.of(context).homeworkLabel, evaluation.homework),
      (S.of(context).behavior, evaluation.behavior),
    ].where((item) => item.$2 != null).toList();
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).weeklyEvaluation,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.black),
          ),
          const SizedBox(height: 8),
          for (final item in values)
            EvaluationMetricRow(
              metric: EvaluationMetricModel(
                title: item.$1,
                percent: '${item.$2!.toStringAsFixed(0)}%',
                value: (item.$2! / 100).clamp(0, 1),
              ),
            ),
          if (evaluation.teacherNote != null) ...[
            const SizedBox(height: 12),
            TeacherNoteCard(note: evaluation.teacherNote!),
          ],
        ],
      ),
    );
  }
}
