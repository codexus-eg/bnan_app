import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/latest_earned_points.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/point_tip_card.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_monthly_performance_table.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_performance_stats_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherPerformanceBody extends StatelessWidget {
  const TeacherPerformanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TeacherPerformanceStatsGrid(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).lastSixMonths,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor15),
                ),
                const SizedBox(height: 8),
                TeacherMonthlyPerformanceTable(),
              ],
            ),
          ),
          SizedBox(height: 16),
          LatestEarnedPointsList(),
          SizedBox(height: 16),
          PointsTipCard(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
