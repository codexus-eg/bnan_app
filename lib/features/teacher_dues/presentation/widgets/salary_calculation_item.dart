import 'package:bnan_app/core/shared_widget/custom_second_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/salary_calc_widget.dart';
import 'package:flutter/material.dart';

class SalaryCalculationItem extends StatelessWidget {
  const SalaryCalculationItem({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.circleColor,
    required this.numberColor,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color circleColor;
  final Color numberColor;

  @override
  Widget build(BuildContext context) {
    return CustomSecondBackground(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: circleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 14,
              horizontal: 11,
            ),
            child: Text(
              number,
              style: StylesManager.styleBold20(
                context,
              ).copyWith(color: numberColor),
            ),
          ),
          const SizedBox(width: 14),
          SalaryCalcWidget(title: title, subtitle: subtitle),
        ],
      ),
    );
  }
}