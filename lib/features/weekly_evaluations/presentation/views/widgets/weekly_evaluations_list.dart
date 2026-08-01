import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsList extends StatelessWidget {
  const WeeklyEvaluationsList({
    super.key,
    required this.evaluations,
    required this.showEditAction,
    this.onEditPressed,
  });

  final List<WeeklyEvaluationUiModel> evaluations;
  final bool showEditAction;
  final ValueChanged<int>? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(evaluations.length, (index) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: index == evaluations.length - 1 ? 0 : 16,
          ),
          child: WeeklyEvaluationCard(
            key: ValueKey(evaluations[index].id),
            evaluation: evaluations[index],
            showEditAction: showEditAction,
            onEditPressed: showEditAction
                ? () => onEditPressed?.call(index)
                : null,
          ),
        );
      }),
    );
  }
}
