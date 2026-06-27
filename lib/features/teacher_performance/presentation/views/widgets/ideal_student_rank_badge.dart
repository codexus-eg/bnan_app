import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_performance/data/models/ideal_student_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IdealStudentRankBadge extends StatelessWidget {
  const IdealStudentRankBadge({super.key, required this.student});

  final IdealStudentItemModel student;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: ColorManager.blueD0DE,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(ImageManager.crownSimple,colorFilter: ColorFilter.mode(ColorManager.mainColor15, BlendMode.srcIn),),
      )
    );
  }
}
