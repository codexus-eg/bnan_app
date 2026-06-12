import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonScheduleInfo extends StatelessWidget {
  const LessonScheduleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).math,
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(height: 6),
        Text(
          "أ/ سارة",
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
