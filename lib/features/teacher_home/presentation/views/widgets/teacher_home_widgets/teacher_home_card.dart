import 'package:bnan_app/core/shared_widget/home_card_widget.dart';
import 'package:bnan_app/core/shared_widget/progress_line.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_card_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherHomeCard extends StatelessWidget {
  const TeacherHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentPoints = 487;
    const int teachersToNextLevel = 24;
    const int pointsToNextLevel = 113;

    return HomeCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TeacherHomeCardHeader(),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                '$currentPoints ',
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.white),
              ),
              Text(
                S.of(context).pointsCount,
                style: StylesManager.styleRegular16(
                  context,
                ).copyWith(color: ColorManager.white),
              ),
            ],
          ),
          const ProgressLine(value: 0.6),
          const SizedBox(height: 8),
          Text(
            S.of(context)
                .nextLevelPointsText(teachersToNextLevel, pointsToNextLevel),
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.white),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
