import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/salary_calculation_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SalaryCalculationMethodCard extends StatelessWidget {
  const SalaryCalculationMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      shadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).salaryCalculationMethod,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
          SizedBox(height: 16),
          SalaryCalculationItem(
            number: '1',
            title: S.of(context).salaryCalculationFormula,
            subtitle: S.of(context).salaryCalculationFormulaDesc,
            circleColor: ColorManager.blueD3,
            numberColor: ColorManager.blue4A,
          ),
          SizedBox(height: 16),
          SalaryCalculationItem(
            number: '2',
            title: S.of(context).addRewardPointsTitle,
            subtitle: S.of(context).addRewardPointsDesc,
            circleColor: ColorManager.greenD6,
            numberColor: ColorManager.green23,
          ),
          SizedBox(height: 16),
          SalaryCalculationItem(
            number: '3',
            title: S.of(context).deductionsTitle,
            subtitle: S.of(context).deductionsDesc,
            circleColor: ColorManager.pinkE9E1,
            numberColor: ColorManager.orangeE4,
          ),
        ],
      ),
    );
  }
}
