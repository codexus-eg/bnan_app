import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/generated/l10n.dart';

class ParentChildCard extends StatelessWidget {
  const ParentChildCard({super.key, required this.child, this.onTap});

  final ParentChildModel child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fullName = child.fullName.trim().isEmpty ? '-' : child.fullName;
    final curriculumName = child.curriculum?.name.trim();
    final classroomName = child.classroom?.name.trim();
    final gradeName = child.grade.trim();
    final curriculum = curriculumName?.isNotEmpty == true
        ? curriculumName!
        : classroomName?.isNotEmpty == true
        ? classroomName!
        : '-';
    final grade = gradeName.isEmpty ? '-' : gradeName;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CustomDetailsWidgetBackground(
        child: Row(
          children: [
            CustomIconBox(imagePath: ImageManager.children),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StylesManager.styleBold16(
                            context,
                          ).copyWith(color: ColorManager.mainColor14),
                        ),
                      ),
                      if (child.isActive case final isActive?) ...[
                        const SizedBox(width: 8),
                        StatusBadge(
                          horizontalPadding: 8,
                          text: isActive
                              ? S.of(context).activated
                              : S.of(context).notActivated,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$curriculum - $grade',
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
      ),
    );
  }
}
