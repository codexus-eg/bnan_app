import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_dues/data/enums/salary_status_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalaryStatusBadge extends StatelessWidget {
  const SalaryStatusBadge({super.key, required this.text, required this.type});

  final String text;
  final SalaryStatusType type;

  Color get backgroundColor => switch (type) {
    SalaryStatusType.paid => ColorManager.greenE9,
    SalaryStatusType.processing => ColorManager.blueE5,
    SalaryStatusType.waiting => ColorManager.pinkFB,
  };
  Color get textColor => switch (type) {
    SalaryStatusType.paid => ColorManager.green23,
    SalaryStatusType.processing => ColorManager.blue007,
    SalaryStatusType.waiting => ColorManager.beigeDAA,
  };
  String get icon => switch (type) {
    SalaryStatusType.paid => ImageManager.teacherAssignmentCheckCircle2,
    SalaryStatusType.processing => ImageManager.arrowGrowthIcon,
    SalaryStatusType.waiting => ImageManager.clockTenIcon,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      width: 90,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: 16,
            width: 16,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
