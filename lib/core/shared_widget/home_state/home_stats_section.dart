import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_state_card.dart';
import 'package:flutter/material.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    super.key,
    required this.states,
    this.crossAxisCount,
    this.childAspectRatio = 1.43,
    this.crossAxisSpacing = 20,
    this.mainAxisSpacing = 16,
    this.showIcon = true,
    this.titleTextAlign,
    this.titleOverflow,
    this.titleColorBuilder,
  });

  final List<HomeStateModel> states;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool showIcon;
  final TextAlign? titleTextAlign;
  final TextOverflow? titleOverflow;
  final Color? Function(int index)? titleColorBuilder;
  @override
  Widget build(BuildContext context) {
    if (crossAxisCount != null) {
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: states.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount!,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          return HomeStatCard(
            state: states[index],
            showIcon: showIcon,
            titleTextAlign: titleTextAlign,
            titleOverflow: titleOverflow,
            titleColor:titleColorBuilder?.call(index) ,
          );
        },
      );
    }

    return Row(
      children: List.generate(states.length * 2 - 1, (index) {
        if (index.isOdd) {
          return const SizedBox(width: 20);
        }
        final itemIndex = index ~/ 2;
        return Expanded(
          child: HomeStatCard(
            titleColor: titleColorBuilder?.call(index),
            state: states[itemIndex],
            showIcon: showIcon,
            titleTextAlign: titleTextAlign,
            titleOverflow: titleOverflow,
          ),
        );
      }),
    );
  }
}
