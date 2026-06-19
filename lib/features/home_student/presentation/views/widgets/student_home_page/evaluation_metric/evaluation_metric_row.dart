import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/evaluation_metric_model.dart';
import 'package:bnan_app/core/shared_widget/progress_line.dart';
import 'package:flutter/material.dart';

class EvaluationMetricRow extends StatelessWidget {
  const EvaluationMetricRow({super.key, required this.metric});

  final EvaluationMetricModel metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              metric.title,
              style: StylesManager.styleRegular12(context).copyWith(
                color: ColorManager.greyA8AF,
              ),
            ),
            const Spacer(),
            Text(
              metric.percent,
              style: StylesManager.styleBold12(context).copyWith(
                color: ColorManager.mainColor14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ProgressLine(value: metric.value),
      ],
    );
  }
}