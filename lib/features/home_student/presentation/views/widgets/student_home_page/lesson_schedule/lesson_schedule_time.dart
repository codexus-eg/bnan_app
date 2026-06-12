import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class LessonScheduleTime extends StatelessWidget {
  const LessonScheduleTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ص',
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '12:00',
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
      ],
    );
  }
}