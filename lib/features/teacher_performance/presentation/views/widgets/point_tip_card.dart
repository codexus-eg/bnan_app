import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PointsTipCard extends StatelessWidget {
  const PointsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      margin: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: ColorManager.white,
      child: Row(
        children: [
          CustomIconBox(
            imagePath: ImageManager.trophyIcon,
            backgroundColor: ColorManager.blueE3,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).tipToIncreasePoints,
                  style: StylesManager.styleBold16(context).copyWith(
                    color: ColorManager.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.of(context).pointsTipDescription,
                  textAlign: TextAlign.right,
                  style: StylesManager.styleRegular14(context).copyWith(
                    color: ColorManager.grey7D7D,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}