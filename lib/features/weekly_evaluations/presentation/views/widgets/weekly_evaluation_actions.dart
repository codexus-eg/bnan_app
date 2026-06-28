import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_action_buttons.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeeklyEvaluationActions extends StatelessWidget {
  const WeeklyEvaluationActions({super.key, required this.evaluation});

  final WeeklyEvaluationModel evaluation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          WeeklyEvaluationInfo(evaluation: evaluation),
          const Spacer(),
          WeeklyEvaluationActionButtons(evaluation: evaluation),
          const SizedBox(width: 17),
          SvgPicture.asset(ImageManager.trash, width: 22),
        ],
      ),
    );
  }
}
