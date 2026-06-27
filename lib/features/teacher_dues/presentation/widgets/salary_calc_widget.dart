import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SalaryCalcWidget extends StatelessWidget {
  const SalaryCalcWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
