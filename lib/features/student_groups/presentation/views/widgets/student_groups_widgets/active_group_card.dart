import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/student_groups_widgets/base_group_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActiveGroupCard extends StatelessWidget {
  const ActiveGroupCard({super.key, required this.enrollment});

  final StudentEnrollmentModel enrollment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => MyNavigator.goTo(context, Routes.groups),
      child: BaseGroupCard(
        child: Row(
          children: [
            CustomIconBox(title: _getFirstLetter(enrollment.classroom.name)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enrollment.classroom.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StylesManager.styleBold16(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                  ),
                  Text(
                    S.of(context).groupCreatedByYou,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StylesManager.styleRegular14(
                      context,
                    ).copyWith(color: ColorManager.greyA8AF),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(ImageManager.chatIcon),
          ],
        ),
      ),
    );
  }

  String _getFirstLetter(String text) {
    if (text.trim().isEmpty) return '';
    return text.trim()[0].toUpperCase();
  }
}
