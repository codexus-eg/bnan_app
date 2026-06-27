import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_state_card.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherPerformanceStatsGrid extends StatelessWidget {
  const TeacherPerformanceStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final states = [
      HomeStateModel(
        icon: ImageManager.clockTenIcon,
        value: '38',
        title: S.of(context).lessons,
        iconColor: ColorManager.orangeE6,
      ),
      HomeStateModel(
        icon: ImageManager.wallet,
        value: '1900',
        title: 'ج.م',
        iconColor: ColorManager.orangeE4,
      ),
      HomeStateModel(
        icon: ImageManager.starIcon,
        value: '850',
        title: S.of(context).point,
        iconColor: ColorManager.orangeE6,
      ),
      HomeStateModel(
        icon: ImageManager.trophyIcon,
        value: '#3',
        title: 'من 25',
        iconColor: ColorManager.blue3A,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: states.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 35,
          childAspectRatio: 1.35,
        ),
        itemBuilder: (context, index) {
          return HomeStatCard(state: states[index]);
        },
      ),
    );
  }
}
