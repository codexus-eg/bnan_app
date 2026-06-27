import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsView extends StatelessWidget {
  const WeeklyEvaluationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).weeklyEvaluations),
      body: const WeeklyEvaluationsBody(),
    );
  }
}
