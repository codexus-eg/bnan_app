import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/evaluation_metric_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/evaluation_metric_row.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/teacher_note_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationSection extends StatelessWidget {
  const WeeklyEvaluationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      EvaluationMetricModel(
        title: S.of(context).attendanceRate,
        percent: '90%',
        value: .90,
      ),
      EvaluationMetricModel(
        title: S.of(context).interactionLevel,
        percent: '85%',
        value: .85,
      ),
      EvaluationMetricModel(
        title: S.of(context).assignmentsEvaluation,
        percent: '95%',
        value: .95,
      ),
    ];

    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
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
          ...List.generate(metrics.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: 8,
              ),
              child: EvaluationMetricRow(metric: metrics[index]),
            );
          }),
          const SizedBox(height: 12),
          const TeacherNoteCard(),
        ],
      ),
    );
  }
}
