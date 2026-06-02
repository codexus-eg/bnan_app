import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_groups/data/models/active_group_model.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/base_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActiveGroupCard extends StatelessWidget {
  const ActiveGroupCard({super.key, required this.group});

  final ActiveGroupModel group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>MyNavigator.goTo(context, Routes.chat),
      child: BaseGroupCard(
        child: Row(
          children: [
            const CustomIconBox(title: 'س'),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.title,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                Text(
                  group.subtitle,
                  style: StylesManager.styleRegular14(context).copyWith(
                    color: ColorManager.greyA8AF
                  ),
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(ImageManager.chatIcon),
          ],
        ),
      ),
    );
  }
}
