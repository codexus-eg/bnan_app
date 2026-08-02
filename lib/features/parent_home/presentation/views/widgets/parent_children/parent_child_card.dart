import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:flutter/material.dart';

class ParentChildCard extends StatelessWidget {
  const ParentChildCard({super.key, required this.child});

  final ParentChildModel child;

  @override
  Widget build(BuildContext context) {
    final fullName = child.fullName.trim().isEmpty ? '-' : child.fullName;
    final classroomName = child.classroom?.name.trim();
    final gradeName = child.classroom?.grade?.name.trim();
    final classroom = classroomName == null || classroomName.isEmpty
        ? '-'
        : classroomName;
    final grade = gradeName == null || gradeName.isEmpty ? '-' : gradeName;

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
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 6),
                Text(
                  '$classroom - $grade',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
