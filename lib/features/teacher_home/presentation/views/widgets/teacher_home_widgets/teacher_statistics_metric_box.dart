import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherStatisticsMetricBox extends StatelessWidget {
  const TeacherStatisticsMetricBox({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.grey7A7C),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: StylesManager.styleBold20(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ],
      ),
    );
  }
}
