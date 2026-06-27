import 'package:bnan_app/features/teacher_performance/data/models/teacher_point_model.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/latest_earned_points_header.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_point_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LatestEarnedPointsList extends StatelessWidget {
  const LatestEarnedPointsList({super.key});

  @override
  Widget build(BuildContext context) {
    final points = [
      TeacherPointModel(
        title: 'إكمال جميع الحصص في الموعد',
        date: S.of(context).today,
        points: 50,
        type: TeacherPointType.reward,
      ),
      TeacherPointModel(
        title: 'تقييم ممتاز من أولياء الأمور',
        date: 'أمس',
        points: 30,
        type: TeacherPointType.reward,
      ),
      TeacherPointModel(
        title: 'تسليم التقييمات الأسبوعية',
        date: S.of(context).today,
        points: 10,
        type: TeacherPointType.reward,
      ),
      TeacherPointModel(
        title: 'تأخر في بدء الحصة',
        date: 'منذ 3 أيام',
        points: -10,
        type: TeacherPointType.deduction,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const LatestEarnedPointsHeader(),
          const SizedBox(height: 8),
          Column(
            children: points
                .map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TeacherPointCard(point: point),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}