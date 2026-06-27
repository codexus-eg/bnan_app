import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/salary_calculation_method_card.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/salary_month_cards.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/teacher_current_month_dues_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherDuesBody extends StatelessWidget {
  const TeacherDuesBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<HomeStateModel> states = [
      HomeStateModel(
        icon: ImageManager.arrowGrowthIcon,
        value: '120',
        title: S.of(context).rewardPoints,
      ),
      HomeStateModel(
        icon: ImageManager.tableIcon,
        value: '38',
        title: S.of(context).sessionsThisMonth,
        iconColor: ColorManager.mainColor14,
      ),
      HomeStateModel(
        icon: ImageManager.wallet,
        value: '3',
        title: S.of(context).packagePrice,
        iconColor: ColorManager.orangeE462,
      ),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(headerText: S.of(context).dues, iconNeeded: false),
            TeacherCurrentMonthDuesCard(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeStatsSection(states: states),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SalaryMonthCards(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SalaryCalculationMethodCard(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
