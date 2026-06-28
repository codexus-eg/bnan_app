import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:flutter/material.dart';

class ParentChildCard extends StatelessWidget {
  const ParentChildCard({super.key,required this.parentChildModel});
final ParentChildModel parentChildModel;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          CustomIconBox(imagePath: ImageManager.children),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 parentChildModel.name,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 6),
                Text(
                  parentChildModel.grade,
                  style: StylesManager.styleRegular14(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
