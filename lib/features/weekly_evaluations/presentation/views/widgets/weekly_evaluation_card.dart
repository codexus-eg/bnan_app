import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeeklyEvaluationCard extends StatelessWidget {
  const WeeklyEvaluationCard({
    super.key,
    required this.evaluation,
    required this.showEditAction,
    this.onEditPressed,
  });

  final WeeklyEvaluationUiModel evaluation;
  final bool showEditAction;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                evaluation.title,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor15),
              ),
            ),
            if (showEditAction)
              IconButton(
                tooltip: S.of(context).editEvaluation,
                onPressed: onEditPressed,
                icon: SvgPicture.asset(ImageManager.edit, width: 20),
              ),
          ],
        ),
        const SizedBox(height: 8),
        WeeklyEvaluationTable(subjects: evaluation.subjects),
      ],
    );
  }
}
