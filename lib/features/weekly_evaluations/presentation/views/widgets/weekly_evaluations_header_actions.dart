import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsHeaderActions extends StatelessWidget {
  const WeeklyEvaluationsHeaderActions({super.key, this.onAddPressed});
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AddNewTopicButton(
        title: S.of(context).addNewEvaluation,
        path: ImageManager.plus,
        onTap: onAddPressed,
      ),
    );
  }
}
