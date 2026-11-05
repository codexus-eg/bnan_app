import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsHeaderActions extends StatelessWidget {
  const WeeklyEvaluationsHeaderActions({
    super.key,
    this.onAddPressed,
    this.onSendAllPressed,
    this.showSendAll = true,
    this.isSending = false,
  });

  final VoidCallback? onAddPressed;
  final VoidCallback? onSendAllPressed;
  final bool showSendAll;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showSendAll) ...[
          Expanded(
            child: AddNewTopicButton(
              title: isSending ? S.of(context).sending : S.of(context).sendAll,
              path: ImageManager.tablerSendIcon,
              onTap: isSending ? null : onSendAllPressed,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: AddNewTopicButton(
            title: S.of(context).addNewEvaluation,
            path: ImageManager.plus,
            onTap: onAddPressed,
          ),
        ),
      ],
    );
  }
}
