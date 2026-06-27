import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationInfo extends StatelessWidget {
  const WeeklyEvaluationInfo({super.key, required this.evaluation});

  final WeeklyEvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).weeklyEvaluation,
          style: StylesManager.styleRegular10(context),
        ),
        Text(
          evaluation.studentName,
          style: StylesManager.styleBold12(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
