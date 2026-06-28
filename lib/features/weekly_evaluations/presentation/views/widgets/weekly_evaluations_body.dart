import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_dummy_data.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/add_weekly_evaluation_button.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsBody extends StatelessWidget {
  const WeeklyEvaluationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: weeklyEvaluationsDummyData.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) return const AddWeeklyEvaluationButton();
        final evaluation = weeklyEvaluationsDummyData[index - 1];
        return WeeklyEvaluationCard(evaluation: evaluation);
      },
    );
  }
}
