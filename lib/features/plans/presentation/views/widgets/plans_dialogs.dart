import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/add_daily_plan_dialog.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/upload_study_plan_dialog.dart';
import 'package:flutter/material.dart';

abstract class PlansDialogs {
  static Future<void> showAdd(BuildContext context, PlansAccessPolicy policy) {
    if (!policy.canAddDailyPlan) return Future.value();
    return AppDialogs.show(
      context: context,
      child: AddDailyPlanDialog(policy: policy),
    );
  }

  static Future<void> showUpload(
    BuildContext context,
    PlansAccessPolicy policy,
  ) {
    if (!policy.canUploadPlan) return Future.value();
    return AppDialogs.show(
      context: context,
      child: const UploadStudyPlanDialog(),
    );
  }
}
