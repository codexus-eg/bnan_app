import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/base_group_card.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/group_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PendingRequestCard extends StatelessWidget {
  const PendingRequestCard({
    super.key,
    required this.enrollment,
  });

  final StudentEnrollmentModel enrollment;

  @override
  Widget build(BuildContext context) {
    return BaseGroupCard(
      child: Row(
        children: [
          CustomIconBox(iconPath: ImageManager.bookIcon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollment.classroom.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold16(context).copyWith(
                    color: ColorManager.mainColor14,
                  ),
                ),
                Text(
                  S.of(context).waitingForTeacherApproval,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleRegular14(context).copyWith(
                    color: ColorManager.greyA8AF,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GroupStatusBadge(text: S.of(context).pending),
        ],
      ),
    );
  }
}