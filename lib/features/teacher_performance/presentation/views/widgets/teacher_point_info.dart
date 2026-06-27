import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherPointInfo extends StatelessWidget {
  const TeacherPointInfo({
    super.key,
    required this.title,
    required this.date,
  });

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}