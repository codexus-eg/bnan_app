import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/ideal_student_score_text.dart';
import 'package:flutter/material.dart';

class IdealStudentScoreChip extends StatelessWidget {
  const IdealStudentScoreChip({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.blueD0DE,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IdealStudentScoreText(points: points,textColor: ColorManager.mainColor14),
    );
  }
}
