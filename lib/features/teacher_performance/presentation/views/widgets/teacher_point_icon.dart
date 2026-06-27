import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class TeacherPointIcon extends StatelessWidget {
  const TeacherPointIcon({super.key, required this.isReward});

  final bool isReward;

  @override
  Widget build(BuildContext context) {
    return CustomIconBox(
      imagePath: isReward
          ? ImageManager.arrowGrowthIcon
          : ImageManager.arrowGrowthDownIcon,
      backgroundColor: isReward ? ColorManager.greenE0 : ColorManager.pinkF9D,
      widgetColor: isReward ? ColorManager.green23 : ColorManager.redD4,
    );
  }
}