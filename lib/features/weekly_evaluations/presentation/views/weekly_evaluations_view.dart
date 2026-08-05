import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_weekly_evaluations_body.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsView extends StatelessWidget {
  const WeeklyEvaluationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = SessionManager.instance.role;
    final policy = WeeklyEvaluationsAccessPolicy.fromRole(
      SessionManager.instance.userRole,
    );
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).weeklyEvaluations),
      body: role == UserRole.student || role == UserRole.parent
          ? const ReadOnlyWeeklyEvaluationsBody()
          : WeeklyEvaluationsBody(policy: policy),
    );
  }
}
