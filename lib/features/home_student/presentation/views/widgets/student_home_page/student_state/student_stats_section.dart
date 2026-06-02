import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/home_student/data/models/student_stat_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_state/student_stat_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentStatsSection extends StatelessWidget {
  const StudentStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      StudentStatModel(
        icon: ImageManager.arrowGrowthIcon,
        value: S.of(context).attendancePercent,
        title: S.of(context).attendance,
        iconColor: 0xff75C8EE,
      ),
      StudentStatModel(
        icon: ImageManager.starIcon,
        value: S.of(context).interactionRate,
        title: S.of(context).interaction,
        iconColor: 0xffE6A72A,
      ),
      StudentStatModel(
        icon: ImageManager.trophyIcon,
        value: S.of(context).certificatesCount,
        title: S.of(context).certificates,
        iconColor: 0xff3E7BD9,
      ),
    ];

    return Row(
      children: List.generate(stats.length * 2 - 1, (index) {
        if (index.isOdd) {
          return const SizedBox(width: 20);
        }
        final itemIndex = index ~/ 2;
        return Expanded(
          child: StudentStatCard(stat: stats[itemIndex]),
        );
      }),
    );
  }
}