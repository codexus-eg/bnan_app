import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansHeaderActions extends StatelessWidget {
  const PlansHeaderActions({
    super.key,
    required this.policy,
    required this.onAdd,
    required this.onUpload,
  });

  final PlansAccessPolicy policy;
  final VoidCallback onAdd;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        if (policy.canAddDailyPlan)
          Expanded(
            child: AddNewTopicButton(
              title: s.addDailyPlanForStudents,
              path: ImageManager.plus,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              onTap: onAdd,
            ),
          ),
        if (policy.canAddDailyPlan && policy.canUploadPlan)
          const SizedBox(width: 8),
        if (policy.canUploadPlan)
          Expanded(
            child: AddNewTopicButton(
              title: s.uploadStudyPlan,
              path: ImageManager.upload,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              onTap: onUpload,
            ),
          ),
      ],
    );
  }
}
