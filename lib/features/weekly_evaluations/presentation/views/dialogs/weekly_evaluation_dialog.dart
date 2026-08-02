import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationDialog extends StatelessWidget {
  const WeeklyEvaluationDialog({super.key, required this.data});

  final EvaluationDialogContext data;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsetsDirectional.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: CustomAppDialog(
        width: 360,
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .86,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: WeeklyEvaluationForm(
                title: data.isEdit
                    ? S.of(context).editEvaluation
                    : S.of(context).newWeeklyEvaluation,
                data: data,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
