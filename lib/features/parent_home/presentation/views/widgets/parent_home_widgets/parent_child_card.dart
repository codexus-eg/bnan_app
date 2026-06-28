import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ParentChildCard extends StatelessWidget {
  const ParentChildCard({super.key, required this.name, required this.grade});

  final String name;
  final String grade;

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
                  name,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 6),
                Text(grade, style: StylesManager.styleRegular14(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
