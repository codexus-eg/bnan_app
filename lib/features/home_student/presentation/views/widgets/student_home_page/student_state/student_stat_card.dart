import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/student_stat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentStatCard extends StatelessWidget {
  const StudentStatCard({super.key, required this.stat});

  final StudentStatModel stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(stat.icon, width: 24, height: 24),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: StylesManager.styleBold20(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 8),
          Text(
            stat.title,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
