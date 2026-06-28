import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddWeeklyEvaluationButton extends StatelessWidget {
  const AddWeeklyEvaluationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AddNewTopicButton(
        title: S.of(context).addNewEvaluation,
        onTap: () => showDialog(
          context: context,
          builder: (_) => WeeklyEvaluationDialog(evaluation: null),
        ),
      ),
    );
  }
}
