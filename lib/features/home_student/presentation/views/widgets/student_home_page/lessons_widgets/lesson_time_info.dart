import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonTimeInfo extends StatelessWidget {
  const LessonTimeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          S.of(context).today,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ' 6:00 م',
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
      ],
    );
  }
}