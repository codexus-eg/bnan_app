import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_groups/data/models/pending_request_model.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/base_group_card.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/group_status_badge.dart';
import 'package:flutter/material.dart';

class PendingRequestCard extends StatelessWidget {
  const PendingRequestCard({super.key, required this.request});

  final PendingRequestModel request;

  @override
  Widget build(BuildContext context) {
    return BaseGroupCard(
      child: Row(
        children: [
          CustomIconBox(iconPath: ImageManager.bookIcon),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.subject,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              Text(
                request.subtitle,
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ],
          ),
          const Spacer(),

          const GroupStatusBadge(text: 'معلق'),
        ],
      ),
    );
  }
}
