import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_performance/data/models/teacher_point_model.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_point_icon.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_point_info.dart';
import 'package:flutter/material.dart';

class TeacherPointCard extends StatelessWidget {
  const TeacherPointCard({super.key, required this.point});

  final TeacherPointModel point;

  @override
  Widget build(BuildContext context) {
    final isReward = point.isReward;

    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: isReward ? ColorManager.greenF4 : ColorManager.pinkFD,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: const Offset(0, 1),
            color: ColorManager.black.withAlpha((255 * .25).round()),
          ),
        ],
      ),
      child: Row(
        children: [
          TeacherPointIcon(isReward: isReward),
          const SizedBox(width: 8),
          TeacherPointInfo(
            title: point.title,
            date: point.date,
          ),
          const Spacer(),
          Text(
            '${isReward ? '+' : ''}${point.points}',
            style: StylesManager.styleBold14(context).copyWith(
              color: isReward ? ColorManager.green23 : ColorManager.redD4,
            ),
          ),
        ],
      ),
    );
  }
}