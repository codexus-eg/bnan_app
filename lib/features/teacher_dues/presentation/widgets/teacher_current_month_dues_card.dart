import 'package:bnan_app/core/shared_widget/home_card_widget.dart';
import 'package:bnan_app/core/shared_widget/progress_line.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/completed_lesson_widget.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/current_month_widget.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/current_profit_widget.dart';
import 'package:flutter/material.dart';

class TeacherCurrentMonthDuesCard extends StatelessWidget {
  const TeacherCurrentMonthDuesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentMonthWidget(),
          const SizedBox(height: 8),
          Text(
            'مايو 2026',
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          CurrentProfitWidget(),
          const SizedBox(height: 8),
          CompletedLessonsWidget(),
          const SizedBox(height: 4),
          const ProgressLine(value: .7),
        ],
      ),
    );
  }
}
