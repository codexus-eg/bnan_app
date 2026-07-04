import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_table_card.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/weekly_evaluation_table_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppbar(headerText: S.of(context).studySchedule ,iconNeeded: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: const [
              ScheduleTableCard(),
              SizedBox(height: 16),
              WeeklyEvaluationTableCard(),
            ],
          ),
        ),
      ],
    );
  }
}